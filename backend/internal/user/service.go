package user

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"log"
	"time"

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

	if !u.Active {
		return nil, errors.New("account is deactivated")
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

func (s *UserServiceServer) GetProfile(ctx context.Context, req *userpb.GetProfileRequest) (*userpb.GetProfileResponse, error) {
	var u User
	if err := db.DB.First(&u, req.UserId).Error; err != nil {
		log.Println("GetProfile error:", err)
		return nil, err
	}

	var dobIso string
	if u.DateOfBirth != nil {
		dobIso = u.DateOfBirth.Format("2006-01-02")
	}

	return &userpb.GetProfileResponse{
		UserId: req.UserId,
		Email:  u.Email,
		Name:   u.Name,
		DobIso: dobIso,
	}, nil
}

func (s *UserServiceServer) UpdateProfile(ctx context.Context, req *userpb.UpdateProfileRequest) (*userpb.UpdateProfileResponse, error) {
	var u User
	if err := db.DB.First(&u, req.UserId).Error; err != nil {
		log.Println("UpdateProfile error:", err)
		return nil, err
	}

	u.Email = req.Email
	u.Name = req.Name

	if req.DobIso == "" {
		u.DateOfBirth = nil
	} else {
		t, err := time.Parse("2006-01-02", req.DobIso)
		if err != nil {
			log.Println("UpdateProfile parse dob error:", err)
			return nil, err
		}
		u.DateOfBirth = &t
	}

	if err := db.DB.Save(&u).Error; err != nil {
		log.Println("UpdateProfile save error:", err)
		return nil, err
	}

	var dobIso string
	if u.DateOfBirth != nil {
		dobIso = u.DateOfBirth.Format("2006-01-02")
	}

	return &userpb.UpdateProfileResponse{
		UserId: req.UserId,
		Email:  u.Email,
		Name:   u.Name,
		DobIso: dobIso,
	}, nil
}

func (s *UserServiceServer) DeactivateAccount(ctx context.Context, req *userpb.DeactivateAccountRequest) (*userpb.DeactivateAccountResponse, error) {
	var u User
	if err := db.DB.First(&u, req.UserId).Error; err != nil {
		log.Println("DeactivateAccount find user error:", err)
		return nil, err
	}

	u.Active = false

	if err := db.DB.Save(&u).Error; err != nil {
		log.Println("DeactivateAccount save error:", err)
		return nil, err
	}

	return &userpb.DeactivateAccountResponse{
		Success: true,
	}, nil
}

func generateToken() (string, error) {
	b := make([]byte, 16) // 128 bits
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	return hex.EncodeToString(b), nil
}
