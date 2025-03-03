// We make functions inside ::TacticalCameraBridge hookable by introducing a hookable proxyCamera squirrel table in between

// Reference to the old getCamera function where we the untouched original from
local oldCamera = ::Tactical.getCamera;

// We use delegation so that we can use the _get and _set metamethods to full effect to emulate reading and writing of member variables of TacticalCameraBridge
local proxyDelegate = {
	_get = function(key)
	{
		if (key in oldCamera().__getTable)
		{
			return oldCamera()[key]; // Get the value from the original camera
		}
		return null; // Default case
	},

	_set = function(key, value)
	{
		if (key in oldCamera().__setTable)
		{
			oldCamera()[key] = value; // Modify the original camera object
		}
	},
};

local proxyCamera = {
// Overloaded Functions
	function isInsideScreen( _pos, _foo = null )
	{
		if (_foo == null) return oldCamera().isInsideScreen(_pos);
		return oldCamera().isInsideScreen(_pos, _foo);
	},
	function setPos( _pos, _foo = null )
	{
		if (_foo == null) return oldCamera().setPos(_pos);
		return oldCamera().setPos(_pos, _foo);
	},
	function screenToWorld( _mouseX, _mouseY = null )
	{
		if (_mouseY == null) return oldCamera().screenToWorld(_mouseX);
		return oldCamera().screenToWorld(_mouseX, _mouseY);
	},
	function move( _x, _y = null )
	{
		if (_y == null) return oldCamera().move(_x);
		return oldCamera().move(_x, _y);
	},
	function moveToPos( _pos, _foo = null, _bar = null )
	{
		if (_foo == null) return oldCamera().moveToPos(_pos);
		if (_bar == null) return oldCamera().moveToPos(_pos, _foo);
		return oldCamera().moveToPos(_pos, _foo, _bar);
	},
	function moveTo( _entity, _foo = null )
	{
		if (_foo == null) return oldCamera().moveTo(_entity);
		return oldCamera().moveTo(_entity, _foo);
	},
	function moveToTile( _tile, _foo = null )
	{
		if (_foo == null) return oldCamera().moveToTile(_tile);
		return oldCamera().moveToTile(_tile, _foo);
	},
	function quake( _attacker, _target, _floatA, _floatB, _floatC = null )
	{
		if (_floatC == null) return oldCamera().quake(_attacker, _target, _floatA, _floatB);
		return oldCamera().quake(_attacker, _target, _floatA, _floatB, _floatC);
	}

// Rest of the Functions
	function cancelMovement() { return oldCamera().cancelMovement(); }
	function jumpTo( _entity ) { return oldCamera().jumpTo(_entity); }
	function climbBy( _integer ) { return oldCamera().climbBy(_integer); }
	function setLevelToHighestOnMap() { return oldCamera().setLevelToHighestOnMap(); }
	function updateEntityOverlays() { return oldCamera().updateEntityOverlays(); }
	function queryEntityOverlays() { return oldCamera().queryEntityOverlays(); }
	function isMoving() { return oldCamera().isMoving(); }
	function isCenteredOnTile( _tile ) { return oldCamera().isCenteredOnTile(_tile); }
	function isMovingToTile( _tile ) { return oldCamera().isMovingToTile(_tile); }
	function moveToTileSlowly( _tile ) { return oldCamera().moveToTileSlowly(_tile); }
	function addEntityOverlay( _entityOverlay ) { return oldCamera().addEntityOverlay(_entityOverlay); }
	function zoomBy( _float ) { return oldCamera().zoomBy(_float); }
	function removeEntityOverlay ( _entity ) { return oldCamera().removeEntityOverlay(_entity); }
	function getBestLevelForTile( _tile ) { return oldCamera().getBestLevelForTile(_tile); }
	function getPos() { return oldCamera().getPos(); }
	function registerCallbacks( _startCallback, _endCallback ) { return oldCamera().registerCallbacks(_startCallback, _endCallback); }
	function removeEntityOverlays() { return oldCamera().removeEntityOverlays(); }
	function render() { return oldCamera().render(); }
	function unregisterCallbacks( _startCallback, _endCallback ) { return oldCamera().unregisterCallbacks(_startCallback, _endCallback); }
	function update() { return oldCamera().update(); }
	function zoomTo( _floatA, _floatB ) { return oldCamera().zoomTo(_floatA, _floatB); }

// Unknown Functions - These are never called in vanilla so I have no clue how many arguments they expect
	function isCenteredOn( _foo ) { return oldCamera().isCenteredOn(_foo); } // ??, maybe an entity?
	function isCenteredOnPos( _foo ) { return oldCamera().isCenteredOnPos(_foo); }	// ???
	function moveToExactly( _foo ) { return oldCamera().moveToExactly(_foo); }	// ???
	function worldToScreen( _foo ) { return oldCamera().worldToScreen(_foo); }	// ???
}

proxyCamera.setdelegate(proxyDelegate);

::Tactical.getCamera = function() {
	return proxyCamera;
}
