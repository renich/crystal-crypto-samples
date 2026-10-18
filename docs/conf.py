# Configuration file for the Sphinx documentation builder.
# crystal-crypto-samples: EVALinux Crypto Suite Integration Harness

project = 'crystal-crypto-samples'
copyright = '2026, Rénich Bon Ćirić (Copyleft)'
author = 'Rénich Bon Ćirić'
release = '0.3.0'

extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.viewcode',
    'sphinx.ext.todo',
]

templates_path = ['_templates']
exclude_patterns = ['_build', 'build', 'technical/api', 'Thumbs.db', '.DS_Store']

html_theme = 'sphinx_rtd_theme'
html_static_path = []
html_title = 'crystal-crypto-samples Documentation'
html_show_sourcelink = False
