#!/usr/bin/env fish
# Clone from https://github.com/Baspar/dotfiles/blob/master/fish/.config/fish/functions/custom_fzf_bindings.fish
function custom_fzf_bindings
  function port-forward -d "Port forward from k8s"
    port-forward.sh --mock | read COMMAND
    if [ "$COMMAND" ]
      commandline -- "$COMMAND"
      commandline -f repaint
    end
  end

  # function connect-gcloud -d "Connect to Gcloud Cluster"
  #   connect-gcloud.sh --mock | read COMMAND
  #   if [ "$COMMAND" ]
  #     commandline -- "$COMMAND"
  #     commandline -f repaint
  #   end
  # end

  function change-gcloud-project -d "Connect to Gcloud Cluster"
    change-gcloud-project.sh --mock | read COMMAND
    if [ "$COMMAND" ]
      commandline -- "$COMMAND"
      commandline -f repaint
    end
  end
end
