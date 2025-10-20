function CheckForSemisolidPlatform(_x, _y)
{
    // Create a return variable
    var _rtrn = noone;

    // We must not be moving upwards, and then we check for a normal collision
    if ySpeed >= 0 && place_meeting(_x, _y, obj_semisolid)
    {
        // Create a DS list to store all colliding instances of obj_semisolid
        var _list = ds_list_create();
        var _listSize = instance_place_list(_x, _y, obj_semisolid, _list, false);

        // Loop through the colliding instances and only return one if it's top is bellow the player
        for (var _i = 0; _i < _listSize; _i++)
        {
            // Get an instance from the list
            var _listInst = _list[| _i];

            // Return a semisolid that is bellow the player
            if _listInst != forgetSemiSolid && floor(bbox_bottom) <= ceil(_listInst.bbox_top - _listInst.ySpeed)
            {
                // Return the ID of the semisolid platform
                _rtrn = _listInst;
                // Break the loop
                _i = _listSize;
            }
        }

        // Destroy the DS list to prevent memory leaks
        ds_list_destroy(_list);
    }

    // Return our variable
    return _rtrn;
}