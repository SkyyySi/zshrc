# My zshrc.

This zshrc was written to be as straigt forward as possible to use. It has no dependencys besides a basic *nix environment and, uh... zsh.
Just put it in <code>~/.zshrc</code> (or <code>$ZDOTDIR/.zshrc</code> if set) and you're good.

<h3>Recommendations</h3>

I <b>highly</b> encurrage anyone using this zshrc to at least install the following plugins alongside it:
<ul>
  <li><a href="https://gist.github.com/romkatv/8b318a610dc302bdbe1487bb1847ad99">instant-zsh</a></li>
  <li><a href="https://github.com/zsh-users/zsh-autosuggestions">zsh-autosuggestions</a></li>
  <li><a href="https://github.com/zsh-users/zsh-completions">zsh-completions</a></li>
  <li><a href="https://github.com/zsh-users/zsh-history-substring-search">zsh-history-substring-search</a></li>
  <li><a href="https://github.com/zsh-users/zsh-syntax-highlighting">zsh-syntax-highlighting</a></li>
</ul>
As a small tip, if you use instant-zsh, you should add the <code>instant-zsh-pre &lt;your prompt&gt;</code> line at the top of this <code>.zshrc</code>
and <code>instant-zsh-post</code> at the bottom of <code>.zshrc.local</code>, so that both files are affected.

<h3>I am currently using oh-my-zsh. Is switching easy?</h3>
Yes it is. This zshrc has a build-in plugin loader. The only thing you need to do is this:
Assuming you have installed oh-my-zsh to the default location, you just need to add the code below to this zshrc (above the theme and plugin loader):
<pre>
if [[ ! -z $(command ls $HOME/.oh-my-zsh/lib/) ]]; then
  for l in $HOME/.oh-my-zsh/lib/*.zsh; do
    . $l
  done
fi
</pre>

<h3>I have my own zshrc, can I use both at the same time?</h3>
Yep. Just put your personal <code>.zshrc</code> in <code>~/.zshrc.local</code> (or <code>$ZDOTDIR/.zshrc.local</code> if set) and it will be loaded like usual.
