package workout

import (
	"time"
)

type WorkoutLog struct {
	ID        uint   `gorm:"primaryKey"`
	UserID    uint   `gorm:"index"`
	Content   string `gorm:"type:text"`
	Category  string `gorm:"size:64"` // e.g. "Chest", "Legs", "Cardio"
	CreatedAt time.Time
	UpdatedAt time.Time
}
