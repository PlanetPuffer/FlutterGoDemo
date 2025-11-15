package user

import "time"

type User struct {
	ID           uint   `gorm:"primaryKey"`
	Email        string `gorm:"uniqueIndex;size:255"`
	PasswordHash string `gorm:"size:255"`

	Name        string     `gorm:"type:varchar(255)"`
	DateOfBirth *time.Time `gorm:"type:date"`

	Active bool `gorm:"default:true"` // for soft deleting users

	CreatedAt time.Time
	UpdatedAt time.Time
}
