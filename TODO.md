# To do

## Active
* Let the user select the mindmap to be displayed from a dropdown menu

## Backlog
* Rename Msg::Refresh to Msg::Load
* Show error message in webpage when compilation fails.
* Relay all errors to the user instead of ignoring them.

### Functionality
* Use elm-css for styling.

### Optimisations

* Recreating the tree from unordered records might be very inefficient,
consider adding a position (Int) field to JsonNode to order the nodes
efficiently.

# Done
* Load tree from JSON.
* Use HTTP to get JSON.
* Let the user input the mindmap to be displayed

# Cancelled
