# Tron-CLU-Theme
<pre>
This is my personal CLU inspired theme.
I have changed nvim motion configs so change it back. Everthing is commented.
</pre>
<h3>CAUTION! these mess with /root/:</h3>

```
# 1. Point YAZI_CONFIG_HOME to your main configuration directory
sudo YAZI_CONFIG_HOME="$HOME/.config/yazi" -E yazi
#   ↑
# add a "env" here if it does not work
                     
# 2. Create the root folder
sudo mkdir -p /root/.config/yazi                                                 

# 3. Symlink it to your local config
sudo ln -s "$HOME/.config/yazi/theme.toml" /root/.config/yazi/theme.toml
```

```
# 1. Make sure these exist
sudo mkdir -p /root/.config                                                     
sudo mkdir -p /root/.local/share                                                 
sudo mkdir -p /root/.local/state /root/.cache                                   

# 2. Symlink to local file
sudo ln -sfn "$HOME/.config/nvim" /root/.config/nvim                             

# 3. Symlink plugins and data
sudo ln -sfn "$HOME/.local/share/nvim" /root/.local/share/nvim                   

# 4. Symlink plugin history, treesitter parsers, and UI state load
sudo ln -sfn "$HOME/.local/state/nvim" /root/.local/state/nvim                 
sudo ln -sfn "$HOME/.cache/nvim" /root/.cache/nvim
```

<table style="font-family:Times New Roman">
  <tr>
    <td>Shell</td>
    <td>Fish</td>
  </tr>
    <tr>
    <td>Bar</td>
    <td>Polybar</td>
  </tr>
    <tr>
    <td>Compositor</td>
    <td>Picom</td>
  </tr>
  <tr>
    <td>Font</td>
    <td><a href="https://github.com/papuSpartan/ttf-encom">Encom</a>, MesloLGL Nerd Font</td>
  </tr>

</table>
<h2 style="font-family:Times New Roman">Screenshots:</h2>
<br>
<h3>Rofi:</h3>
<!--rofi-->
<img width="416" height="533" alt="image" src="https://github.com/user-attachments/assets/65817d18-e08d-48e5-a957-3128fc9a5fe5" />

<!--DESKTOP SS-->

<img width="1365" height="767" alt="2026-05-26_15-42_1" src="https://github.com/user-attachments/assets/94d423e1-6f93-4be1-b5e5-d2b9e3132b3e" />
<img width="1365" height="767" alt="2026-06-27_12-35_1" src="https://github.com/user-attachments/assets/112e17bf-5b5d-4990-9542-8ed306987904" />


<h3 style="font-family:Times New Roman">Floating terminal</h3>
<table style="font-family:Times New Roman">
<tr>
<td>Toggle</td>
<td>Alt+T</td>
</tr>
</table>

<img width="1365" height="767" alt="image" src="https://github.com/user-attachments/assets/1c515fb6-f7a1-48a0-9a9d-74c37f591de5" />


