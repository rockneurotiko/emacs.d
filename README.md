# emacs config

# Clone
`git clone --recursive https://github.com/rockneurotiko/emacs.git`

# Optional dependencies:
- plantuml
Download the jar to /opt/plantuml/plantuml.jar or change the path in settings/random-requires.el

- tern
`sudo npm install -g tern`

- python
`sudo pip install jedi flake8 importmagic autopep8 yapf`

- gcal
Follow this: https://github.com/myuhe/org-gcal.el
And then, in ~/.emacs.d/tokens.el, write this:

```
(setq gcal-client-id "YOUR_CLIENT_ID")
(setq gcal-client-secret "YOUR_CLIENT_SECRET")
(setq gcal-email "YOUR_EMAIL")
```
