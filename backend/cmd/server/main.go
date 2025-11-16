package main

import (
	"log"
	"net"
	"net/http"

	"github.com/improbable-eng/grpc-web/go/grpcweb"
	"google.golang.org/grpc"

	"github.com/PlanetPuffer/FlutterGoDemo/backend/internal/db"
	userpb "github.com/PlanetPuffer/FlutterGoDemo/backend/internal/proto"
	"github.com/PlanetPuffer/FlutterGoDemo/backend/internal/user"
	"github.com/PlanetPuffer/FlutterGoDemo/backend/internal/workout"
)

func main() {
	// Connect DB
	db.Init()

	// Auto migrate User and WorkoutLog tables
	if err := db.DB.AutoMigrate(
		&user.User{},
		&workout.WorkoutLog{},
	); err != nil {
		log.Fatalf("auto migrate failed: %v", err)
	}

	// --- Plain gRPC server on :50051 (for native clients) ---
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer()
	userSvc := &user.UserServiceServer{}
	userpb.RegisterUserServiceServer(grpcServer, userSvc)

	// Serve plain gRPC in a goroutine
	go func() {
		log.Println("gRPC server listening on :50051")
		if err := grpcServer.Serve(lis); err != nil {
			log.Fatalf("failed to serve gRPC: %v", err)
		}
	}()

	// --- gRPC-Web wrapper on :8080 (for browser / Flutter web) ---
	wrapped := grpcweb.WrapServer(
		grpcServer,
		grpcweb.WithOriginFunc(func(origin string) bool {
			// For demo purposes, allow all origins.
			// Tighten this in production.
			return true
		}),
	)

	httpHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if wrapped.IsGrpcWebRequest(r) ||
			wrapped.IsGrpcWebSocketRequest(r) ||
			wrapped.IsAcceptableGrpcCorsRequest(r) {
			wrapped.ServeHTTP(w, r)
			return
		}

		w.WriteHeader(http.StatusNotFound)
		_, _ = w.Write([]byte("not found"))
	})

	httpServer := &http.Server{
		Addr:    ":8080",
		Handler: httpHandler,
	}

	log.Println("gRPC-Web server listening on :8080")
	if err := httpServer.ListenAndServe(); err != nil {
		log.Fatalf("failed to serve gRPC-Web HTTP: %v", err)
	}
}
