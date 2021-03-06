DeviceLayout = require('./deviceLayout')
EditorSelector = require('./editorSelector')
EditorWrapper = require('./editorWrapper')

# # # # #

class HelpView extends Marionette.LayoutView
  template: require './templates/help_view'
  className: 'row h-100 align-items-center'

# # # # #

class LayoutView extends Marionette.LayoutView
  template: require './templates/layout'
  className: 'container-fluid d-flex flex-column w-100 h-100 device--layout'

  regions:
    deviceRegion:   '[data-region=device]'
    selectorRegion: '[data-region=selector]'
    # editorRegion:   '[data-region=editor]'

  onRender: ->

    # Displays default help text
    @showHelpView()

    # Instantiates a new DeviceLayout for connecting to an AstroKey
    # and selecting which key the user would like to edit
    deviceView = new DeviceLayout({ model: @model })
    deviceView.on 'key:selected', (keyModel) => @showEditorView(keyModel, 'macro')
    # deviceView.on 'key:selected', (keyModel) => @showEditorSelector(keyModel)
    deviceView.on 'key:deselected', () => @showHelpView()
    @deviceRegion.show(deviceView)

    # Macro Development hack
    # setTimeout( =>
    #   @showEditorView(@model.get('keys').first(), 'macro')
    # , 1000)
    # @showEditorView(@model.get('keys').first(), 'macro')

  showHelpView: ->

    # Instantiates a new HelpView and shows it in @selectorRegion
    @selectorRegion.show new HelpView()

  showEditorSelector: (keyModel) ->

    # Instantaiates new EditorSelector view
    editorSelector = new EditorSelector({ model: keyModel })

    # Shows Macro Editor
    editorSelector.on 'show:macro:editor', => @showEditorView(keyModel, 'macro')

    # Shows Text Editor
    editorSelector.on 'show:text:editor', => @showEditorView(keyModel, 'text')

    # Shows Key Editor
    editorSelector.on 'show:key:editor', => @showEditorView(keyModel, 'key')

    # Shows the EditorSelector view
    @selectorRegion.show(editorSelector)

  showEditorView: (keyModel, editor) ->

    # Adjusts the CSS to display the EditorWrapper
    # @$el.addClass('active')

    # Reads macro from device
    # NOTE - this happens asynchronously
    # We _should_ not render the EditorWrapper view until if a device is not present,
    # but we will in the meantime for demonstration purposes
    keyModel.readMacro()

    # Instantiates new EditorWrapper view
    editorWrapper = new EditorWrapper({ model: keyModel, editor: editor })

    # Handles 'cancel' event
    editorWrapper.on 'cancel', =>
      @selectorRegion.show new HelpView()
    #   @$el.removeClass('active')

    # Handles 'save' event
    editorWrapper.on 'save', =>
      @selectorRegion.show new HelpView()
    #   # TODO - hit the KeyModel / DeviceModel to do the rest from here
    #   @$el.removeClass('active')

    # Shows the EditorWrapper view in @editorRegion
    # @editorRegion.show(editorWrapper)
    @selectorRegion.show(editorWrapper)

# # # # #

module.exports = LayoutView



