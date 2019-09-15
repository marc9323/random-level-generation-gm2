/// o_level Create

randomize(); // generate random numbers

// get the tile layer map id
var _wall_map_id = layer_tilemap_get_id("WallTiles");

// set up grid
width_ = room_width div CELL_WIDTH;
height_ = room_height div CELL_HEIGHT;
grid_ = ds_grid_create(width_, height_);
ds_grid_set_region(grid_, 0, 0, width_, height_, VOID);

// create the controller, a single controller that steps around the grid and sets floor tiles
var _controller_x = width_ div 2
var _controller_y = height_ div 2
var _controller_direction = irandom(3); // tween 0, right, 1, up, 2, left  - 3, right
var _steps = 400; // how many steps controller will walk around in level, > = more floor tiles

var _direction_change_odds = 1;

repeat(_steps) {
	// set current x, y to FLOOR
	grid_[# _controller_x, _controller_y] = FLOOR;
	
	// randomize the direction
	if(irandom(_direction_change_odds) == _direction_change_odds) {
		_controller_direction = irandom(3);
	}
	
	// Move the controller
	var _x_direction = lengthdir_x(1, _controller_direction * 90);
	var _y_direction = lengthdir_y(1, _controller_direction * 90);
	_controller_x += _x_direction;
	_controller_y += _y_direction;
	
	// make sure controller doesn't go outside the grid
	// 2 blocks on each side of the game that we can't go into
	if(_controller_x < 2 || _controller_x >= width_ - 2) {
		_controller_x += -_x_direction * 2; // step two back in current x direction	
	}
	if(_controller_y < 2 || _controller_y >= height_ - 2) {
		_controller_y += -_y_direction * 2; // step two back in current x direction	
	}
	
}

// loop through grid and create tiles ??? why -1?
// so it will never be an end tile where progress in a given
// direction may not be possible
 for(var _y = 1; _y < height_ -1; _y++) {
	for( var _x = 1; _x < width_ -1; _x++) {
		// if we are NOT on a floor tile
		if(grid_[# _x, _y] != FLOOR){
			// check each cardinal direction
			var _north_tile = grid_[# _x, _y - 1] == VOID; // is tile north (above) VOID?
			var _west_tile = grid_[# _x - 1, _y] == VOID; // is tile to the west (left) VOID?
			var _east_tile = grid_[# _x + 1, _y] == VOID; // is tile to east (right) VOID?
			var _south_tile = grid_[# _x, _y + 1] == VOID; // is tile to the south (below) VOID?
			
			// bitmasking method
			
			// Game Maker 2 starts counting it's tiles at 1 ( 0 tile is always a blank tile ) so we add 1
			var _tile_index = NORTH * _north_tile + WEST * _west_tile + EAST * _east_tile + SOUTH * _south_tile + 1;
			
			if(_tile_index == 1){ // wall tile in our tileset
				grid_[# _x, _y] = FLOOR; // no empty holes
			}
		}
	}
}


for(var _y = 1; _y < height_ -1; _y++) {
	for( var _x = 1; _x < width_ -1; _x++) {
		// if we are on a floor tile
		if(grid_[# _x, _y] == FLOOR){
			// set WallTiles tilmap index x, y to tileset index # 1
			tilemap_set(_wall_map_id, 1, _x, _y);
		}
	}
}


// NOTES:

// NOTE 1:  Game Maker 2 starts counting it's tiles at 1 so we add 1

