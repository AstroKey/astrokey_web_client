
# KeyModel class definition
class KeyModel extends Backbone.RelationalModel

  # Default attributes
  defaults: {}

# # # # #

class KeyCollection extends Backbone.Collection
  model: KeyModel
  comparator: 'order'

# # # # #

module.exports =
  Model:      KeyModel
  Collection: KeyCollection
