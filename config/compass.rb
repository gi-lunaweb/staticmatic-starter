
http_path         = ""                # root when deployed
sass_dir          = "src/stylesheets"   # dir containing Sass / Compass source files
css_dir           = "site/stylesheets"  # final CSS
images_dir        = "site/images"       # final images
output_style      = :expanded            # CSS is nice and compact

line_comments     = ARGV[0] == 'build' ? false : true

# To enable relative paths to assets via compass helper functions. Uncomment:
relative_assets = true


project_type = :staticmatic