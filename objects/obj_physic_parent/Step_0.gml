/// @description Physic logic

// Get xSpeed and ySpeed
event_user(0);

// Handle the solid platforms
HandleMovePlatforms();

// Handle the X Speed
HandleXSpeed();

// Handle the Y Speed
HandleYSpeed();

// Handle the final move platforms
HandleFinalMovePlatforms();