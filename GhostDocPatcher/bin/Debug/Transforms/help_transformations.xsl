<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
  
  <!-- stuff specified to comments authored in DDUEXML -->

	<!-- stuff specified to comments authored in DDUEXML -->
  <!--<xsl:param name="omitXmlnsBoilerplate" select="'false'" />-->
  <xsl:include href="html_body_header.xsl"/>
  <xsl:include href="html_body_navigation.xsl"/>
  <xsl:include href="html_body.xsl"/>
  <xsl:include href="html_body_footer.xsl"/>
  
  <xsl:include href="utilities_reference.xsl" />

  <!--
  <xsl:variable name="summary" select="normalize-space(/document/comments/summary)" />
  <xsl:variable name="abstractSummary" select="/document/comments/summary" />
  <xsl:variable name="hasSeeAlsoSection" select="boolean((count(/document/comments//seealso | /document/reference/elements/element/overloads//seealso) > 0)  or 
                           ($group='type' or $group='member' or $group='list'))"/>
  <xsl:variable name="examplesSection" select="boolean(string-length(/document/comments/example[normalize-space(.)]) > 0)"/>
  <xsl:variable name="languageFilterSection" select="boolean(string-length(/document/comments/example[normalize-space(.)]) > 0)" />

  -->
  <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="save" content="history"/>
        <title>
          <xsl:call-template name="topicTitlePlain"/>
        </title>
        <xsl:call-template name="insertStylesheets" />
        <xsl:call-template name="insertScripts" />
        <xsl:call-template name="insertFilename" />
        <xsl:call-template name="insertMetadata" />
      </head>
      <body>
        <xsl:call-template name="bodyHeader"/>
        <xsl:call-template name="main"/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template name="getParameterDescription">
    <xsl:param name="name" />
    <xsl:apply-templates select="/document/comments/param[@name=$name]" />
  </xsl:template>

  <xsl:template name="getReturnsDescription">
    <xsl:param name="name" />
    <xsl:apply-templates select="/document/comments/param[@name=$name]" />
  </xsl:template>

  <!--
  <xsl:template name="getElementDescription">
    <xsl:apply-templates select="summary[1]" />
  </xsl:template>

  <xsl:template name="getOverloadSummary">
    <xsl:apply-templates select="overloads" mode="summary"/>
  </xsl:template>

  <xsl:template name="getOverloadSections">
    <xsl:apply-templates select="overloads" mode="sections"/>
  </xsl:template>

  <xsl:template name="getInternalOnlyDescription">

  </xsl:template>
  -->


  <!-- block sections -->

  <xsl:template match="summary">
    <div class="summary">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="overloads" mode="summary">
    <xsl:choose>
      <xsl:when test="count(summary) > 0">
        <xsl:apply-templates select="summary" />
      </xsl:when>
      <xsl:otherwise>
        <div class="summary">
          <xsl:apply-templates/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="overloads" mode="sections">
    <xsl:apply-templates select="remarks" />
    <xsl:apply-templates select="example"/>
  </xsl:template>

  <xsl:template match="value">
    <xsl:call-template name="subSection">
      <xsl:with-param name="title">
        <include item="fieldValueTitle" />
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:apply-templates />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="returns">
    <xsl:call-template name="subSection">
      <xsl:with-param name="title">
        <include item="methodValueTitle" />
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:apply-templates />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="templates">
    <xsl:call-template name="subSection">
      <xsl:with-param name="toggleSwitch" select="'templates'" />
      <xsl:with-param name="title">
        <include item="templatesTitle" />
      </xsl:with-param>
      <xsl:with-param name="content">
        <dl>
          <xsl:for-each select="template">
            <xsl:variable name="templateName" select="@name" />
            <dt>
              <span class="parameterItalic">
                <xsl:value-of select="$templateName"/>
              </span>
            </dt>
            <dd>
              <xsl:apply-templates select="/document/comments/typeparam[@name=$templateName]" />
            </dd>
          </xsl:for-each>
        </dl>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="remarks">
    <xsl:call-template name="section">
      <xsl:with-param name="toggleSwitch" select="'remarks'"/>
      <xsl:with-param name="title">
        <include item="remarksTitle" />
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:apply-templates />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="example">
    <xsl:call-template name="section">
      <xsl:with-param name="toggleSwitch" select="'example'"/>
      <xsl:with-param name="title">
        <include item="examplesTitle" />
      </xsl:with-param>
      <xsl:with-param name="content">
            <xsl:apply-templates />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="para">
    <p>
      <xsl:apply-templates />
    </p>
  </xsl:template>

  <xsl:template match="code">

    <xsl:variable name="codeLang">
      <xsl:choose>
        <xsl:when test="@language = 'vbs'">
          <xsl:text>VBScript</xsl:text>
        </xsl:when>
        <xsl:when test="@language = 'vb' or @language = 'vb#'  or @language = 'VB'" >
          <xsl:text>VisualBasic</xsl:text>
        </xsl:when>
        <xsl:when test="@language = 'c#' or @language = 'cs' or @language = 'C#'" >
          <xsl:text>CSharp</xsl:text>
        </xsl:when>
        <xsl:when test="@language = 'cpp' or @language = 'cpp#' or @language = 'c' or @language = 'c++' or @language = 'C++'" >
          <xsl:text>ManagedCPlusPlus</xsl:text>
        </xsl:when>
        <xsl:when test="@language = 'j#' or @language = 'jsharp'">
          <xsl:text>JSharp</xsl:text>
        </xsl:when>
        <xsl:when test="@language = 'js' or @language = 'jscript#' or @language = 'jscript' or @language = 'JScript'">
          <xsl:text>JScript</xsl:text>
        </xsl:when>
        <xsl:when test="@language = 'xml'">
          <xsl:text>xmlLang</xsl:text>
        </xsl:when>
        <xsl:when test="@language = 'html'">
          <xsl:text>html</xsl:text>
        </xsl:when>
        <xsl:when test="@language = 'vb-c#'">
          <xsl:text>visualbasicANDcsharp</xsl:text>
        </xsl:when>
        <xsl:when test="@language = 'xaml' or @language = 'XAML'">
          <xsl:text>XAML</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>other</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="codeSection">
      <xsl:with-param name="codeLang" select="$codeLang" />
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="contracts">
    <xsl:variable name="requires" select="/document/comments/requires" />
    <xsl:variable name="ensures" select="/document/comments/ensures" />
    <xsl:variable name="ensuresOnThrow" select="/document/comments/ensuresOnThrow" />
    <xsl:variable name="invariants" select="/document/comments/invariant" />
    <xsl:variable name="setter" select="/document/comments/setter" />
    <xsl:variable name="getter" select="/document/comments/getter" />
    <xsl:variable name="pure" select="/document/comments/pure" />
    <xsl:if test="$requires or $ensures or $ensuresOnThrow or $invariants or $setter or $getter or $pure">
      <xsl:call-template name="section">
        <xsl:with-param name="toggleSwitch" select="'contracts'"/>
        <xsl:with-param name="title">
          <include item="contractsTitle" />
        </xsl:with-param>
        <xsl:with-param name="content">
          <!--Purity-->
          <xsl:if test="$pure">
            <xsl:text>This method is pure.</xsl:text>
          </xsl:if>
          <!--Contracts-->
          <div class="tableSection">
            <xsl:if test="$getter">
              <xsl:variable name="getterRequires" select="$getter/requires"/>
              <xsl:variable name="getterEnsures" select="$getter/ensures"/>
              <xsl:variable name="getterEnsuresOnThrow" select="$getter/ensuresOnThrow"/>
              <xsl:call-template name="subSection">
                <xsl:with-param name="title">
                  <include item="getterTitle" />
                </xsl:with-param>
                <xsl:with-param name="content">
                  <xsl:if test="$getterRequires">
                    <xsl:call-template name="contractsTable">
                      <xsl:with-param name="title">
                        <include item="requiresNameHeader"/>
                      </xsl:with-param>
                      <xsl:with-param name="contracts" select="$getterRequires"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="$getterEnsures">
                    <xsl:call-template name="contractsTable">
                      <xsl:with-param name="title">
                        <include item="ensuresNameHeader"/>
                      </xsl:with-param>
                      <xsl:with-param name="contracts" select="$getterEnsures"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="$getterEnsuresOnThrow">
                    <xsl:call-template name="contractsTable">
                      <xsl:with-param name="title">
                        <include item="ensuresOnThrowNameHeader"/>
                      </xsl:with-param>
                      <xsl:with-param name="contracts" select="$getterEnsuresOnThrow"/>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="$setter">
              <xsl:variable name="setterRequires" select="$setter/requires"/>
              <xsl:variable name="setterEnsures" select="$setter/ensures"/>
              <xsl:variable name="setterEnsuresOnThrow" select="$setter/ensuresOnThrow"/>
              <xsl:call-template name="subSection">
                <xsl:with-param name="title">
                  <include item="setterTitle" />
                </xsl:with-param>
                <xsl:with-param name="content">
                  <xsl:if test="$setterRequires">
                    <xsl:call-template name="contractsTable">
                      <xsl:with-param name="title">
                        <include item="requiresNameHeader"/>
                      </xsl:with-param>
                      <xsl:with-param name="contracts" select="$setterRequires"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="$setterEnsures">
                    <xsl:call-template name="contractsTable">
                      <xsl:with-param name="title">
                        <include item="ensuresNameHeader"/>
                      </xsl:with-param>
                      <xsl:with-param name="contracts" select="$setterEnsures"/>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="$setterEnsuresOnThrow">
                    <xsl:call-template name="contractsTable">
                      <xsl:with-param name="title">
                        <include item="ensuresOnThrowNameHeader"/>
                      </xsl:with-param>
                      <xsl:with-param name="contracts" select="$setterEnsuresOnThrow"/>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="$requires">
              <xsl:call-template name="contractsTable">
                <xsl:with-param name="title">
                  <include item="requiresNameHeader"/>
                </xsl:with-param>
                <xsl:with-param name="contracts" select="$requires"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="$ensures">
              <xsl:call-template name="contractsTable">
                <xsl:with-param name="title">
                  <include item="ensuresNameHeader"/>
                </xsl:with-param>
                <xsl:with-param name="contracts" select="$ensures"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="$ensuresOnThrow">
              <xsl:call-template name="contractsTable">
                <xsl:with-param name="title">
                  <include item="ensuresOnThrowNameHeader"/>
                </xsl:with-param>
                <xsl:with-param name="contracts" select="$ensuresOnThrow"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="$invariants">
              <xsl:call-template name="contractsTable">
                <xsl:with-param name="title">
                  <include item="invariantsNameHeader"/>
                </xsl:with-param>
                <xsl:with-param name="contracts" select="$invariants"/>
              </xsl:call-template>
            </xsl:if>
          </div>
          <!--Contracts link-->
          <div class="contractsLink">
            <a>
              <xsl:attribute name="target">
                <xsl:text>_blank</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="href">
                <xsl:text>http://msdn.microsoft.com/en-us/devlabs/dd491992.aspx</xsl:text>
              </xsl:attribute>
              <xsl:text>Learn more about contracts</xsl:text>
            </a>
          </div>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="contractsTable">
    <xsl:param name="title"/>
    <xsl:param name="contracts"/>
    <table width="100%" cellspacing="3" cellpadding="5" frame="lhs" >
      <tr>
        <th class="contractsNameColumn">
          <xsl:copy-of select="$title"/>
        </th>
      </tr>
      <xsl:for-each select="$contracts">
        <tr>
          <td>
            <div class="code" style="margin-bottom: 0pt; white-space: pre-wrap;">
              <pre style="margin-bottom: 0pt">
              <xsl:value-of select="."/>
            </pre>
          </div>
        <xsl:if test="@description or @inheritedFrom or @exception">
              <div style="font-size:95%; margin-left: 10pt;
                        margin-bottom: 0pt">
              <table 
               class="contractaux"
               width="100%" frame="void" rules="none" border="0">
                <colgroup>
                  <col width="10%"/>
                  <col width="90%"/>
                </colgroup>
          <xsl:if test="@description">
                  <tr style="border-bottom: 0px none;">
                    <td style="border-bottom: 0px none;">
                      <i><xsl:text>Description: </xsl:text></i>
                    </td>
                    <td style="border-bottom: 0px none;">
                      <xsl:value-of select="@description"/>
                    </td>
                  </tr>              
          </xsl:if>
          <xsl:if test="@inheritedFrom">
                  <tr style="border-bottom: 0px none;">
                    <td style="border-bottom: 0px none;">
                      <i><xsl:text>Inherited From: </xsl:text></i>
                    </td>
                    <td style="border-bottom: 0px none;">
                      <referenceLink target="{@inheritedFrom}">
                        <xsl:value-of select="@inheritedFromTypeName"/>
                      </referenceLink>
                    </td>
                  </tr>
          </xsl:if>
          <xsl:if test="@exception">
                  <tr style="border-bottom: 0px none;">
                    <td style="border-bottom: 0px none;">
                      <i><xsl:text>Exception: </xsl:text></i>
                    </td>
                    <td style="border-bottom: 0px none;">
                      <referenceLink target="{@exception}" qualified="true" />
                    </td>
                  </tr>
          </xsl:if>
              </table>
              </div>
        </xsl:if>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="list[@type='bullet' or @type='']" name="t_bulletList">
    <ul>
      <xsl:for-each select="item">
        <li>
          <xsl:choose>
            <xsl:when test="term or description">
              <xsl:if test="term">
                <strong><xsl:apply-templates select="term" /></strong>
                <xsl:text> - </xsl:text>
              </xsl:if>
              <xsl:apply-templates select="description" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates />
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template match="list[@type='number']" name="t_numberList">
    <ol>
      <xsl:if test="@start">
        <xsl:attribute name="start">
          <xsl:value-of select="@start"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:for-each select="item">
        <li>
          <xsl:choose>
            <xsl:when test="term or description">
              <xsl:if test="term">
                <strong><xsl:apply-templates select="term" /></strong>
                <xsl:text> - </xsl:text>
              </xsl:if>
              <xsl:apply-templates select="description" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates />
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </xsl:for-each>
    </ol>
  </xsl:template>

  <xsl:template match="list[@type='definition']">
   <dl>
     <xsl:for-each select="item">
       <dt>
         <strong><xsl:apply-templates select="term"/></strong>
       </dt>
       <dd>
         <xsl:apply-templates select="description"/>
       </dd>
     </xsl:for-each>
    </dl>
  </xsl:template>

  <xsl:template match="list[@type='table']" name="t_tableList">
    <div class="tableSection">
      <table>
        <xsl:for-each select="listheader">
        <tr>
        <xsl:for-each select="*">
          <th>
            <xsl:apply-templates/>
          </th>
        </xsl:for-each>
        </tr>
        </xsl:for-each>
        <xsl:for-each select="item">
        <tr>
        <xsl:for-each select="*">
          <td>
            <xsl:apply-templates/>
          </td>
        </xsl:for-each>
        </tr>
        </xsl:for-each>
      </table>
    </div>
  </xsl:template>

  <!-- inline tags -->

  <xsl:template match="see[@cref]">
    <xsl:choose>
      <xsl:when test="normalize-space(.)">
        <referenceLink target="{@cref}">
          <xsl:value-of select="." />
        </referenceLink>
      </xsl:when>
      <xsl:otherwise>
        <referenceLink target="{@cref}"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="see[@href]">
    <xsl:choose>
      <xsl:when test="normalize-space(.)">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
          </xsl:attribute>
	    <xsl:if test="@target">
              <xsl:attribute name="target">
                <xsl:value-of select="@target"/>
              </xsl:attribute>
            </xsl:if>
	    <xsl:if test="@alt">
              <xsl:attribute name="alt">
                <xsl:value-of select="@alt"/>
              </xsl:attribute>
            </xsl:if>
          <xsl:value-of select="." />
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
          </xsl:attribute>
	    <xsl:if test="@target">
              <xsl:attribute name="target">
                <xsl:value-of select="@target"/>
              </xsl:attribute>
            </xsl:if>
	    <xsl:if test="@alt">
              <xsl:attribute name="alt">
                <xsl:value-of select="@alt"/>
              </xsl:attribute>
            </xsl:if>
          <xsl:value-of select="@href" />
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="seealso[@href]">
    <xsl:param name="displaySeeAlso" select="false()" />
    <xsl:if test="$displaySeeAlso">
      <xsl:choose>
        <xsl:when test="normalize-space(.)">
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="@href"/>
            </xsl:attribute>
	    <xsl:if test="@target">
              <xsl:attribute name="target">
                <xsl:value-of select="@target"/>
              </xsl:attribute>
            </xsl:if>
	    <xsl:if test="@alt">
              <xsl:attribute name="alt">
                <xsl:value-of select="@alt"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="." />
          </a>
        </xsl:when>
        <xsl:otherwise>
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="@href"/>
            </xsl:attribute>
	    <xsl:if test="@target">
              <xsl:attribute name="target">
                <xsl:value-of select="@target"/>
              </xsl:attribute>
            </xsl:if>
	    <xsl:if test="@alt">
              <xsl:attribute name="alt">
                <xsl:value-of select="@alt"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="@href" />
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="see[@langword]">
    <span class="keyword">
      <xsl:choose>
        <xsl:when test="@langword='null' or @langword='Nothing' or @langword='nullptr'">
          <span class="languageSpecificText">
            <span class="cs">null</span>
            <span class="vb">Nothing</span>
            <span class="cpp">nullptr</span>
          </span>
        </xsl:when>
        <xsl:when test="@langword='static' or @langword='Shared'">
          <span class="languageSpecificText">
            <span class="cs">static</span>
            <span class="vb">Shared</span>
            <span class="cpp">static</span>
          </span>
        </xsl:when>
        <xsl:when test="@langword='virtual' or @langword='Overridable'">
          <span class="languageSpecificText">
            <span class="cs">virtual</span>
            <span class="vb">Overridable</span>
            <span class="cpp">virtual</span>
          </span>
        </xsl:when>
        <xsl:when test="@langword='true' or @langword='True'">
          <span class="languageSpecificText">
            <span class="cs">true</span>
            <span class="vb">True</span>
            <span class="cpp">true</span>
          </span>
        </xsl:when>
        <xsl:when test="@langword='false' or @langword='False'">
          <span class="languageSpecificText">
            <span class="cs">false</span>
            <span class="vb">False</span>
            <span class="cpp">false</span>
          </span>
        </xsl:when>
        <xsl:when test="@langword='abstract'">
          <span class="languageSpecificText">
            <span class="cs">abstract</span>
            <span class="vb">MustInherit</span>
            <span class="cpp">abstract</span>
          </span>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@langword" />
        </xsl:otherwise>
      </xsl:choose>
    </span>
    <xsl:choose>
      <xsl:when test="@langword='null' or @langword='Nothing' or @langword='nullptr'">
        <span class="nu">
          <include item="nullKeyword"/>
        </span>
      </xsl:when>
      <xsl:when test="@langword='static' or @langword='Shared'">
        <span class="nu">
          <include item="staticKeyword"/>
        </span>
      </xsl:when>
      <xsl:when test="@langword='virtual' or @langword='Overridable'">
        <span class="nu">
          <include item="virtualKeyword"/>
        </span>
      </xsl:when>
      <xsl:when test="@langword='true' or @langword='True'">
        <span class="nu">
          <include item="trueKeyword"/>
        </span>
      </xsl:when>
      <xsl:when test="@langword='false' or @langword='False'">
        <span class="nu">
          <include item="falseKeyword"/>
        </span>
      </xsl:when>
      <xsl:when test="@langword='abstract'">
        <span class="nu">
          <include item="abstractKeyword"/>
        </span>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="seealso">
    <xsl:param name="displaySeeAlso" select="false()" />
    <xsl:if test="$displaySeeAlso">
      <xsl:choose>
        <xsl:when test="normalize-space(.)">
          <referenceLink target="{@cref}" qualified="true">
            <xsl:value-of select="." />
          </referenceLink>
        </xsl:when>
        <xsl:otherwise>
          <referenceLink target="{@cref}" qualified="true" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="c">
    <span class="code">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="paramref">
    <span class="parameterItalic">
      <xsl:value-of select="@name" />
    </span>
  </xsl:template>

  <xsl:template match="typeparamref">
    <span class="typeparameter">
      <xsl:value-of select="@name" />
    </span>
  </xsl:template>

  <xsl:template match="syntax">
    <xsl:if test="count(*) > 0">
      <xsl:call-template name="section">
        <xsl:with-param name="toggleSwitch" select="'syntax'" />
        <xsl:with-param name="title">
          <include item="syntaxTitle"/>
        </xsl:with-param>
        <xsl:with-param name="content">
          <xsl:call-template name="syntaxBlocks" />
          <!-- parameters & return value -->
          <xsl:apply-templates select="/document/reference/templates" />
          <xsl:apply-templates select="/document/reference/parameters" />
          <xsl:apply-templates select="/document/comments/value" />
          <xsl:apply-templates select="/document/comments/returns" />
          <xsl:apply-templates select="/document/reference/implements" />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!--<xsl:template name="runningHeader">
    <include item="runningHeaderText" />
  </xsl:template>-->

  <!-- pass through html tags -->

  <xsl:template match="p|ol|ul|li|dl|dt|dd|table|tr|th|td|a|img|b|i|strong|em|del|sub|sup|br|hr|h1|h2|h3|h4|h5|h6|pre|div|span|blockquote|abbr|acronym|u|font|map|area">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>

  <!-- extra tag support -->

  <xsl:template match="threadsafety">
    <xsl:call-template name="section">
      <xsl:with-param name="toggleSwitch" select="'threadSafety'" />
      <xsl:with-param name="title">
        <include item="threadSafetyTitle" />
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:choose>
          <xsl:when test="normalize-space(.)">
            <xsl:apply-templates />
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="@static='true'">
              <include item="staticThreadSafe" />
            </xsl:if>
            <xsl:if test="@static='false'">
              <include item="staticNotThreadSafe" />
            </xsl:if>
            <xsl:if test="@instance='true'">
              <include item="instanceThreadSafe" />
            </xsl:if>
            <xsl:if test="@instance='false'">
              <include item="instanceNotThreadSafe" />
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="note">
    <div class="alert">
      <xsl:attribute name="type">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="@type='tip'">
          <span>
            <img class="note">
              <includeAttribute name="alt" item="tipAltText" />
              <includeAttribute name="title" item="tipAltText" />
              <includeAttribute item="iconPath" name="src">
                <parameter>alert_note.gif</parameter>
              </includeAttribute>
            </img>
          </span>
          <span>
          <include item="tipTitle" />
          </span>
        </xsl:when>
        <xsl:when test="@type='caution' or @type='warning'">
          <span>
            <img class="note">
              <includeAttribute name="alt" item="cautionAltText" />
              <includeAttribute name="title" item="cautionAltText" />
              <includeAttribute item="iconPath" name="src">
                <parameter>alert_caution.gif</parameter>
              </includeAttribute>
            </img>
          </span>
          <span>
            <include item="cautionTitle" />
          </span>
        </xsl:when>
        <xsl:when test="@type='security note' or @type='security'">
          <span>
            <img class="note">
              <includeAttribute name="alt" item="securityAltText" />
              <includeAttribute name="title" item="securityAltText" />
              <includeAttribute item="iconPath" name="src">
                <parameter>alert_security.gif</parameter>
              </includeAttribute>
            </img>
          </span>
          <span>
            <include item="securityTitle" />
          </span>
        </xsl:when>
        <xsl:when test="@type='important'">
          <span>
            <img class="note">
              <includeAttribute name="alt" item="importantAltText" />
              <includeAttribute name="title" item="importantAltText" />
              <includeAttribute item="iconPath" name="src">
                <parameter>alert_caution.gif</parameter>
              </includeAttribute>
            </img>
          </span>
          <span>
            <include item="importantTitle" />
          </span>
        </xsl:when>
        <xsl:when test="@type='visual basic note' or @type='vb' or @type='VB' or @type='VisualBasic'">
          <span>
            <img class="note">
              <includeAttribute name="alt" item="visualBasicAltText" />
              <includeAttribute name="title" item="visualBasicAltText" />
              <includeAttribute item="iconPath" name="src">
                <parameter>alert_note.gif</parameter>
              </includeAttribute>
            </img>
          </span>
          <span>
            <include item="visualBasicTitle" />
          </span>
        </xsl:when>
        <xsl:when test="@type='visual c# note' or @type='cs' or @type='c#' or @type='C#' or @type='CSharp'">
          <span>
            <img class="note">
              <includeAttribute name="alt" item="visualC#AltText" />
              <includeAttribute name="title" item="visualC#AltText" />
              <includeAttribute item="iconPath" name="src">
                <parameter>alert_note.gif</parameter>
              </includeAttribute>
            </img>
          </span>
          <span>
            <include item="visualC#Title" />
          </span>
        </xsl:when>
        <xsl:when test="@type='visual c++ note' or @type='cpp' or @type='CPP' or @type='c++' or @type='C++'">
          <span>
            <img class="note">
              <includeAttribute name="alt" item="visualC++AltText" />
              <includeAttribute name="title" item="visualC++AltText" />
              <includeAttribute item="iconPath" name="src">
                <parameter>alert_note.gif</parameter>
              </includeAttribute>
            </img>
          </span>
          <span>
            <include item="visualC++Title" />
          </span>
        </xsl:when>
        <xsl:when test="@type='visual j# note' or @type='j#' or @type='J#' or @type='JSharp'">
          <span>
            <img class="note">
              <includeAttribute name="alt" item="visualJ#AltText" />
              <includeAttribute name="title" item="visualJ#AltText" />
              <includeAttribute item="iconPath" name="src">
                <parameter>alert_note.gif</parameter>
              </includeAttribute>
            </img>
          </span>
          <span>
            <include item="visualJ#Title" />
          </span>
        </xsl:when>
        <xsl:when test="@type='note'">
          <span>
            <img class="note">
              <includeAttribute name="alt" item="noteAltText" />
              <includeAttribute name="title" item="noteAltText" />
              <includeAttribute item="iconPath" name="src">
                <parameter>alert_note.gif</parameter>
              </includeAttribute>
            </img>
          </span>
          <span>
            <include item="noteTitle" />
          </span>
        </xsl:when>
        <xsl:otherwise>
          <span>
            <img class="note">
              <includeAttribute name="alt" item="noteAltText" />
              <includeAttribute name="title" item="noteAltText" />
              <includeAttribute item="iconPath" name="src">
                <parameter>alert_note.gif</parameter>
              </includeAttribute>
            </img>
          </span>
          <span>
            <include item="{@type}" />
          </span>
        </xsl:otherwise>
      </xsl:choose>
      <span>
        <xsl:text> </xsl:text>
        <include item="noteTitle" />
      </span>
      <br />
      <span class="body">
        <xsl:apply-templates />
      </span>
    </div>
  </xsl:template>

  <xsl:template match="preliminary">
    <div class="preliminary">
      <include item="preliminaryText" />
    </div>
  </xsl:template>

  <!-- move these off into a shared file -->

  <!--
  <xsl:template name="section">
    <xsl:param name="toggleSwitch" />
    <xsl:param name="title" />
    <xsl:param name="content" />

    <! - -<xsl:variable name="toggleTitle" select="concat($toggleSwitch,'Toggle')" />- - >
    <xsl:variable name="toggleSection" select="concat($toggleSwitch,'Section')" />

    <div class="LW_CollapsibleArea_Container">
      <div class="LW_CollapsibleArea_TitleDiv">
        <h2 class="LW_CollapsibleArea_Title">
          <xsl:copy-of select="$title" />
        </h2>
        <div class="LW_CollapsibleArea_HrDiv"><hr class="LW_CollapsibleArea_Hr" /></div>
      </div>

      <a id="{$toggleSection}"><xsl:comment/></a>
      <xsl:copy-of select="$content" />
    </div>
  </xsl:template>
  -->
  
  <!--<xsl:template name="subSection">
    <xsl:param name="title" />
    <xsl:param name="content" />

    <h4 class="subHeading">
      <xsl:copy-of select="$title" />
    </h4>
    <xsl:copy-of select="$content" />

  </xsl:template>

  <xsl:template name="memberIntro">
    <xsl:if test="$subgroup='members'">
      <p>
        <xsl:apply-templates select="/document/reference/containers/summary"/>
      </p>
    </xsl:if>
    <xsl:call-template name="memberIntroBoilerplate"/>
  </xsl:template>-->

  <xsl:template name="codelangAttributes">
    <xsl:call-template name="mshelpCodelangAttributes">
      <xsl:with-param name="snippets" select="/document/comments/example/code" />
    </xsl:call-template>
  </xsl:template>

  <!-- Footer stuff -->

  <xsl:template name="foot">
    <div id="footer">

      <div class="footerLine">
        <img width="100%" height="3px">
          <includeAttribute name="src" item="iconPath">
            <parameter>footer.gif</parameter>
          </includeAttribute>
          <includeAttribute name="alt" item="footerImage" />
          <includeAttribute name="title" item="footerImage" />
        </img>
      </div>
      
      <include item="footer">
        <parameter>
          <xsl:value-of select="$key"/>
        </parameter>
        <parameter>
          <xsl:call-template name="topicTitlePlain"/>
        </parameter>
        <parameter>
          <xsl:value-of select="/document/metadata/item[@id='PBM_FileVersion']" />
        </parameter>
        <parameter>
          <xsl:value-of select="/document/metadata/attribute[@name='TopicVersion']" />
        </parameter>
      </include>
    </div>
  </xsl:template>
</xsl:stylesheet>
