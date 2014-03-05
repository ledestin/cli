require "thor"

class Thor::Shell::Color
  def can_display_colors?
    ! Ninefold::Stdio.robot_mode
  end
end
