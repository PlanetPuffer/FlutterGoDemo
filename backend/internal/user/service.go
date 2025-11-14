package user

import (
	"context"
	"errors"
	"log"

	"github.com/PlanetPuffer/FlutterGoDemo/backend/internal/db"
	userpb "github.com/PlanetPuffer/FlutterGoDemo/backend/internal/proto"
)

type UserServiceServer struct {
	userpb.UnimplementedUserServiceServer
}

// Note: this is for demo only!!! Passwords are stored as plain text here to reduce complexity.
func (s *UserServiceServer) Register(ctx context.Context, req *userpb.RegisterRequest) (*userpb.RegisterResponse, error) {
	u := User{
		Email:        req.Email,
		PasswordHash: req.Password,
	}

	if err := db.DB.Create(&u).Error; err != nil {
		log.Println("Register error:", err)
		return nil, err
	}

	return &userpb.RegisterResponse{
		Id:    uint64(u.ID),
		Email: u.Email,
	}, nil
}

func (s *UserServiceServer) Login(ctx context.Context, req *userpb.LoginRequest) (*userpb.LoginResponse, error) {
	var u User
	if err := db.DB.Where("email = ?", req.Email).First(&u).Error; err != nil {
		log.Println("Login error: user not found:", err)
		return nil, err
	}

	if u.PasswordHash != req.Password {
		return nil, errors.New("invalid credentials")
	}

	// simple fake token for demo
	token := "fake-token-" + u.Email

	return &userpb.LoginResponse{
		Id:    uint64(u.ID),
		Email: u.Email,
		Token: token,
	}, nil
}

func (s *UserServiceServer) GetUser(ctx context.Context, req *userpb.GetUserRequest) (*userpb.GetUserResponse, error) {
	var u User
	if err := db.DB.First(&u, req.Id).Error; err != nil {
		log.Println("GetUser error:", err)
		return nil, err
	}

	return &userpb.GetUserResponse{
		Id:    uint64(u.ID),
		Email: u.Email,
	}, nil
}
