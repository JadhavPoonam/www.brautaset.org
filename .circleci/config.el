;; Don't use inline CSS for source code
(setq org-html-htmlize-output-type "css")

(setq org-html-footnotes-section
      "<div id=\"footnotes\"><!--%s-->%s</div>")

(defun sb/org-html-format-drawer (name content)
  (concat "<div class=\"drawer " (downcase name) "\">\n"
	  "<h6>" (capitalize name) "</h6>\n"
	  content
	  "\n</div>"))

(defun sb/html-head (prefix)
  (format "
       <link rel=\"stylesheet\" type=\"text/css\" href=\"%setc/main.css\" />
       <link rel=\"icon\" type=\"image/png\" href=\"%setc/icon.png\" />
       <link rel=\"alternative\" type=\"application/rss+xml\"
	     href=\"https://www.brautaset.org/index.xml\"
	     title=\"Stig's Soapbox RSS Feed\" />
       <meta name=\"referrer\" content=\"same-origin\">
" prefix prefix))

(setq sb/copyright
      "<p>Copyright &copy; 2011-2019 Stig Brautaset</p>")

(defun sb/preamble (prefix)
  (format "
	 <nav>
	   <ul>
	     <li><a accesskey=\"H\" href=\"%sindex.html\"> Home </a></li>
	     <li><a accesskey=\"p\" href=\"%spublications.html\"> Publications </a></li>
	     <li><a accesskey=\"A\" href=\"%sabout.html\"> About </a></li>
	   </ul>
	 </nav>
       " prefix prefix prefix))

(defun sb/postamble (prefix)
  (concat
   (sb/preamble prefix)
   sb/copyright))

(setq org-publish-project-alist
      `(("www"
	 :components ("www-pages" "www-articles" "www-static" "www-rss"))

	("www-static"
	 :base-directory "~/blog"
	 :publishing-directory "~/public_html"
	 :base-extension "css\\|jpg\\|png\\|pdf\\|html"
	 :recursive t
	 :publishing-function org-publish-attachment)

	("www-pages"
	 :exclude ",.*"
	 :base-directory "~/blog"
	 :publishing-directory "~/public_html"
	 :publishing-function org-html-publish-to-html
	 :section-numbers nil
	 :time-stamp-file nil
	 :with-toc nil
	 :with-drawers t
	 :html-format-drawer-function sb/org-html-format-drawer

	 :html-html5-fancy t
	 :html-doctype "html5"
	 :html-preamble ,(sb/preamble "")
	 :html-postamble ,(sb/postamble "")
	 :html-head ,(sb/html-head "")

	 :html-head-include-default-style nil
	 :html-head-include-scripts nil

	 :html-metadata-timestamp-format "%e %B %Y")

	("www-articles"
	 :exclude ",.*"
	 :base-directory "~/blog/articles"
	 :publishing-directory "~/public_html/articles"
	 :publishing-function org-html-publish-to-html
	 :recursive t
	 :section-numbers nil
	 :time-stamp-file nil
	 :with-toc nil
	 :with-drawers t
	 :html-format-drawer-function sb/org-html-format-drawer

	 :html-html5-fancy t
	 :html-doctype "html5"
	 :html-postamble ,(sb/postamble "../../")
	 :html-head ,(sb/html-head "../../")

	 :html-head-include-default-style nil
	 :html-head-include-scripts nil

	 :html-metadata-timestamp-format "%e %B %Y")

	("www-rss"
	 :base-directory "~/blog"
	 :base-extension "org"
	 :html-link-home "https://www.brautaset.org"
	 :html-link-use-abs-url t
	 :rss-extension "xml"
	 :publishing-directory "~/public_html"
	 :publishing-function (org-rss-publish-to-rss)
	 :section-numbers nil
	 :exclude ".*"              ;; To exclude all files...
	 :include ("index.org")     ;; ... except index.org.
	 :table-of-contents nil)))

;; This goes in RSS header, I think...
(setq user-mail-address "stig@brautaset.org")
