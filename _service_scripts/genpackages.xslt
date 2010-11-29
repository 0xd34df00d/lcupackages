<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<packages>
			<xsl:apply-templates/>
		</packages>
	</xsl:template>
	<xsl:template match="files">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="file">
		<xsl:apply-templates select="document(.)/*">
			<xsl:with-param name="path"
				select="substring(.,3,(string-length(.)-7) div 2)"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="package">
		<xsl:param name="path"/>
		<package><!-- type="{@type}" language="{@language}">-->
			<!--<dirname><xsl:value-of select="$path"/></dirname>-->
			<xsl:apply-templates/>
		</package>
	</xsl:template>

	<xsl:template match="package/name">
		<name>
			<xsl:value-of select="text()"/>
		</name>
	</xsl:template>

	<xsl:template match="versions">
		<versions>
			<xsl:for-each select="*">
				<xsl:copy-of select=".">
					<xsl:apply-templates/>
				</xsl:copy-of>
			</xsl:for-each>
		</versions>
	</xsl:template>
	
	<xsl:template match="*|@*|text()"/>
</xsl:stylesheet>
