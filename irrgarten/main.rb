# frozen_string_literal: true

require_relative 'textUI'
require_relative 'controller'
require_relative 'game'

module Main

  view = UI::TextUI.new
  game = Irrgarten::Game.new(4)
  controller = Control::Controller.new(game, view)
  controller.play

end