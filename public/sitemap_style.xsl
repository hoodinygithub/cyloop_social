<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:sitemap="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>Sitemap: Cyloop</title>
      </head>
      <body>
        <h1><a href="/">Sitemap: Cyloop</a></h1>
        <ul>
        <xsl:for-each select="sitemap:urlset/sitemap:url">
          <li>
            <a>
              <xsl:attribute name="href"><xsl:value-of select="sitemap:loc"/></xsl:attribute>
              <xsl:value-of select="sitemap:loc"/>
            </a>
          </li>
        </xsl:for-each>
        </ul>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>

