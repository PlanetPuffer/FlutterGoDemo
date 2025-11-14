package user

import (
	"context"
	"log"
	"time"

	"github.com/PlanetPuffer/FlutterGoDemo/backend/internal/db"
	userpb "github.com/PlanetPuffer/FlutterGoDemo/backend/internal/proto"
	"github.com/PlanetPuffer/FlutterGoDemo/backend/internal/workout"
)

func toWorkoutLogMessage(m *workout.WorkoutLog) *userpb.WorkoutLogMessage {
	return &userpb.WorkoutLogMessage{
		Id:            uint64(m.ID),
		UserId:        uint64(m.UserID),
		Content:       m.Content,
		CreatedAtUnix: m.CreatedAt.Unix(),
		UpdatedAtUnix: m.UpdatedAt.Unix(),
	}
}

func (s *UserServiceServer) CreateWorkoutLog(
	ctx context.Context,
	req *userpb.CreateWorkoutLogRequest,
) (*userpb.CreateWorkoutLogResponse, error) {
	logEntry := workout.WorkoutLog{
		UserID:  uint(req.UserId),
		Content: req.Content,
	}

	if err := db.DB.Create(&logEntry).Error; err != nil {
		log.Println("CreateWorkoutLog error:", err)
		return nil, err
	}

	return &userpb.CreateWorkoutLogResponse{
		Log: toWorkoutLogMessage(&logEntry),
	}, nil
}

func (s *UserServiceServer) ListWorkoutLogs(
	ctx context.Context,
	req *userpb.ListWorkoutLogsRequest,
) (*userpb.ListWorkoutLogsResponse, error) {
	var logs []workout.WorkoutLog

	if err := db.DB.
		Where("user_id = ?", req.UserId).
		Order("created_at DESC").
		Find(&logs).Error; err != nil {
		log.Println("ListWorkoutLogs error:", err)
		return nil, err
	}

	resp := &userpb.ListWorkoutLogsResponse{
		Logs: make([]*userpb.WorkoutLogMessage, 0, len(logs)),
	}

	for i := range logs {
		resp.Logs = append(resp.Logs, toWorkoutLogMessage(&logs[i]))
	}

	return resp, nil
}

func (s *UserServiceServer) UpdateWorkoutLog(
	ctx context.Context,
	req *userpb.UpdateWorkoutLogRequest,
) (*userpb.UpdateWorkoutLogResponse, error) {
	var logEntry workout.WorkoutLog

	if err := db.DB.
		Where("id = ? AND user_id = ?", req.Id, req.UserId).
		First(&logEntry).Error; err != nil {
		log.Println("UpdateWorkoutLog find error:", err)
		return nil, err
	}

	logEntry.Content = req.Content
	logEntry.UpdatedAt = time.Now()

	if err := db.DB.Save(&logEntry).Error; err != nil {
		log.Println("UpdateWorkoutLog save error:", err)
		return nil, err
	}

	return &userpb.UpdateWorkoutLogResponse{
		Log: toWorkoutLogMessage(&logEntry),
	}, nil
}

func (s *UserServiceServer) DeleteWorkoutLog(
	ctx context.Context,
	req *userpb.DeleteWorkoutLogRequest,
) (*userpb.DeleteWorkoutLogResponse, error) {
	if err := db.DB.
		Where("id = ? AND user_id = ?", req.Id, req.UserId).
		Delete(&workout.WorkoutLog{}).Error; err != nil {
		log.Println("DeleteWorkoutLog error:", err)
		return nil, err
	}

	return &userpb.DeleteWorkoutLogResponse{
		Success: true,
	}, nil
}
