package user

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"log"

	"golang.org/x/crypto/bcrypt"

	"github.com/PlanetPuffer/FlutterGoDemo/backend/internal/db"
	userpb "github.com/PlanetPuffer/FlutterGoDemo/backend/internal/proto"
)

type UserServiceServer struct {
	userpb.UnimplementedUserServiceServer
}

// Note: Password hashing added
func (s *UserServiceServer) Register(ctx context.Context, req *userpb.RegisterRequest) (*userpb.RegisterResponse, error) {
	// hash password before storing
	hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		log.Println("bcrypt error:", err)
		return nil, err
	}

	u := User{
		Email:        req.Email,
		PasswordHash: string(hash),
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

	// compare password with hash
	if err := bcrypt.CompareHashAndPassword([]byte(u.PasswordHash), []byte(req.Password)); err != nil {
		return nil, errors.New("invalid credentials")
	}

	token, err := generateToken()
	if err != nil {
		log.Println("token generation error:", err)
		return nil, err
	}

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

func generateToken() (string, error) {
	b := make([]byte, 16) // 128 bits
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	return hex.EncodeToString(b), nil
}
