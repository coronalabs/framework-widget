Specification Document for: tableView (widget)
==============================================

## Example:

The options table below is completely optional. Example shows all possible keys it can hold. Since the tableView is based on the scrollView widget, it takes the same parameters to construct the scrollView, plus more.

---

		local options = {
		
			-- scrollView parameters
		
		    width = number,     -- default display.contentWidth
		    height = number,    -- default display.contentHeight
		    mask = string,      -- asset filename for bitmap mask (used for clipping boundaries)
		    maskBaseDir = dir,  -- can be: system.ResourceDirectory, system.DocumentsDirectory, etc.
		    left = number,      -- default 0
		    top = number,       -- default 0
			bgColor = table,	-- { r(0-255), g(0-255), b(0-255), a(0-255) }
		
			-- tableView specific parameters
			renderAsNeeded = boolean,	-- default false; determines whether list is "virtualized" or not
		}

		local tableView = widget.create( "tableView", options )
---

## PROPERTIES

### ._view

### ._rows

---

## METHODS

### tableView.insertRowAtTop( rowListener, stickyRow )

**rowListener** is a function that handles the rendering of the row item, as well as it's pressed and released states.

**stickyRow** makes the row item "stick" to the top of the tableView when it passes, commonly used as a category heading.

		-- Example:
		
		--[[ row listener event table will contain the following keys:
			* event.target 	- the actual row item
			* event.phase	- can be "render", "selected", "released", "swipeLeft", "swipeRight"
		--]]
	
		for i=1,#data do	-- data is a table that holds specific info for each row; varies from app to app
			local function rowListener[i]( event )
				local target = event.target		-- corresponds to actual row item display group
				local phase = event.phase		-- one of: "render", "selected", "released"
				
				if event.phase == "render" then
					
				elseif event.phase == "selected" then
					
				elseif event.phase == "released" then
					
				end
			end
		
			tableView:insertRowAtTop( rowListener[i], false )
		end

### tableView.insertRowAtBottom( rowListener, stickyRow )

**rowListener** is a function that handles the rendering of the row item, as well as it's pressed and released states.

**stickyRow** makes the row item "stick" to the top of the tableView when it passes, commonly used as a category heading.

		-- Example:
	
		for i=1,#data do	-- data is a table that holds specific info for each row; varies from app to app
			local function rowListener[i]( event )
				local target = event.target		-- corresponds to actual row item display group
				local phase = event.phase		-- one of: "render", "selected", "released"
				
				if event.phase == "render" then
					
				elseif event.phase == "selected" then
					
				elseif event.phase == "released" then
					
				end
			end
		
			tableView:insertRowAtBottom( rowListener[i], false )
		end

### tableView:insertRowAtPosition( insertAtPosition, rowListener, stickyRow )

**insertAtPosition** is the location in the list where you want the new row to be inserted (will shift other rows down).

**rowListener** is a function that handles the rendering of the row item, as well as it's pressed and released states.

**stickyRow** makes the row item "stick" to the top of the tableView when it passes, commonly used as a category heading.
	
		-- Example:
	
		for i=1,#data do	-- data is a table that holds specific info for each row; varies from app to app
			local function rowListener[i]( event )
				local target = event.target		-- corresponds to actual row item display group
				local phase = event.phase		-- one of: "render", "selected", "released"
				
				if phase == "render" then
				
					-- create background rectangle or gradient, content for row item, etc.
				
				elseif phase == "selected" then
				
					-- change fill color for row item's background, etc.
				
				elseif phase == "released" then
					
					-- reset fill color for row background
					-- do whatever's supposed to happen when user touches and releases the row item
					
				end
			end
		
			tableView:insertRowAtPosition( 2, rowListener[i], false )
		end

---

## CHANGES FROM PREVIOUS WIDGET IMPLEMENTATION:

* No more shortcut properties (such as setting x/y of widget), with an exception of the removeSelf() method. All other changes to widget's display object must be done to it's ._view property.

* Display object is accessed via tableView._view property rather than tableView.view