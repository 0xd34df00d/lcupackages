<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict">
	<xsl:template match="/">
		<div class="packagediv">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="package">
		<div class="packagepreamble">
			<em class="packagetype"><xsl:value-of select="@type"/></em>
			<xsl:if test="@type='plugin' or @type='translation'">
				<br/>
				<em class="packagelang"><xsl:value-of select="@language"/></em>
			</xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="package/name">
		<h2 class="packagename"><xsl:value-of select="text()"/></h2>
	</xsl:template>
	
	<xsl:template match="description">
		<h4 class="packagedescr"><xsl:value-of select="text()"/></h4>
	</xsl:template>
	
	<xsl:template match="versions/version[1]">
		<div class="packageversion"><xsl:value-of select="text()"/></div>
	</xsl:template>
	<xsl:template match="versions/version[position()>1]"/>
		
	<xsl:template match="tags">
		<div class="tagcloud">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="tag">
		<span class="tag"><xsl:value-of select="text()"/></span>
	</xsl:template>
	
	<xsl:template match="thumbnails/thumbnail">
		<img src="{@url}" style="thumbnailimg"/>
	</xsl:template>
	
	<xsl:template match="long">
		<div class="longdescr"><xsl:value-of select="text()"/></div>
	</xsl:template>
	
	<xsl:template match="maintainer">
		<div class="maintblock"><xsl:apply-templates/></div>
	</xsl:template>
	
	<xsl:template match="maintainer/name">
		<div class="maintname"><xsl:value-of select="text()"/></div>
	</xsl:template>
	
	<xsl:template match="maintainer/email">
		<div class="maintemail"><a href="{concat('mailto:',text())}"><xsl:value-of select="text()"/></a></div>
	</xsl:template>
	
	<xsl:template match="*|@*|text()"/>
</xsl:stylesheet>
