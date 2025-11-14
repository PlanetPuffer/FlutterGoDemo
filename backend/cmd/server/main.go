package main

import (
	"log"
	"net"

	"github.com/PlanetPuffer/FlutterGoDemo/backend/internal/db"
	userpb "github.com/PlanetPuffer/FlutterGoDemo/backend/internal/proto"
	"github.com/PlanetPuffer/FlutterGoDemo/backend/internal/user"
	"google.golang.org/grpc"
)

func main() {
	// connect DB
	db.Init()

	// auto migrate User table
	if err := db.DB.AutoMigrate(&user.User{}); err != nil {
		log.Fatalf("auto migrate failed: %v", err)
	}

	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer()
	userSvc := &user.UserServiceServer{}

	userpb.RegisterUserServiceServer(grpcServer, userSvc)

	log.Println("gRPC server listening on :50051")
	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
