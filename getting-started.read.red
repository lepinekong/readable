Title: {Getting started with ReAdable Human Format}
Sub-Title: {step by step guide}

Intro: [
.text: {<a href='/'><b><font color='red'>Re</font>A<font color='red'>d</font></a>ABLE human format</b></a> is meant to be very easy to read, to write and to generate.
<br>We eat our own dog food: this step by step guide has been generated with <a href='/'><b><font color='red'>Re</font>A<font color='red'>d</font></a>ABLE human format</b></a>. Source is available <a href='getting-started.read.red'>here</a>.
}]

Usage: [
    .title: {Usage}

    .sub-title: {Step 1. Create your readable document in any text editor}
    .text: {Create a learn-khmer.txt file in a notepad, or <b>learn-khmer.read.red</b> file 
if you use <a href='https://code.visualstudio.com/'>VSCode</a> to benefit from syntax highlighting with <a href='https://marketplace.visualstudio.com/items?itemName=red-auto.red'>&#82;ed extension</a>.<br>
Write this simplified business requirements document for a learning khmer site:}
    .code: {
title: "Learn Khmer"
sub-title: "Khmer consonants"

Intro: [
     .text: {Description is:}
     .quote: {Learn Khmer<br>It's easy!}
]

logo: [
     .title: "Logo"
     .text: {logo is not available yet}
     image: %img/logo.png ; not available yet
]

     
menu: [
     .title: {Home | Lessons | Contact | About}
]
          
Content: [

     .title: "Kor, Khor, Kour, Khour"
     .text: "ក Kor"
     .text: "ខ Khor"
     .text: "គ Kour"
     .text: "ឃ Khour"

     .title: "Gnor, Chor, Chhor, Chour"
     .text: "ង Gnor"
     .text: "ខ Chor"
     .text: "ឆ Chhor"
     .text: "ជ Chour"

]

Footer: [
     .sub-title: {Copyrigth Lépine Kong}
]
    }
    .text: {Rules are very few and simple:}
    .quote: {1. a block of paragraphs is delimited with brackets [] and has a label like "Content:" 
<br>
2. Document title and sub-title are not enclosed by brackets
<br>
3. tags like .title, .text, .quote, .image are prefixed with dot . otherwise it acts as meta-tags. 
Same result if it is an unknown tag (in the future you'll be able to define custom tags).
<br>
4. text is either enclosed by double quotes "" or curly braces {}. Curly braces allow multi-lines contrary to double quotes. 
<br>
That's all you need to know as business user except one more thing: if ever your text contains any word containing "&#82;ed" (red is ok) you must replace this string by "&#x26;#82;ed" (in a future evolution, we'll do it for you.)
<br>
If you are a webdesigner or a developer, you may have to deal with html entities encoding:
<br> 
4.1 you can generally embed braces inside braces without the need to escape character except if it is ambiguous in that case use &#94; to prefix a curly brace,
for example &#94;^}. If you need to show red escape character &#94;, you must html encode it with &#x26;#94; (see <a href='https://www.freeformatter.com/html-entities.html'>https://www.freeformatter.com/html-entities.html</a>)
<br>
4.2 you can use html tags like &#x3C;br&#x3E; or &#x3C;a href=&#x27;...&#x27;&#x3E;&#x3C;/a&#x3E; inside text. If you want to show html tags litterally, you must encode them (use an online encoder like <a href='https://mothereff.in/html-entities'>https://mothereff.in/html-entities</a>)
    }

    .sub-title: {Step 2. Create a build script}
    .text: {There are 2 main ways to do so. }
    .text: {<br>Usual way is to create a separate script file learn-khmer.red for our example with this code:}
    .code: {
article: load %learn-khmer.read.2.red ; article is mandatory name
do https://readable.red
.markdown-gen ; to generate markdown 
.html-gen ; to generate html
    }
    .text: {. prefix is not mandatory it's our convention to differentiate a function or command from a variable name.}


    .sub-title: {Step 3. If not done yet, install &#82;ed and optionally VSCode with &#82;ed extension}
    .text: {Install only older version, for windows: <a href='https://static.red-lang.org/dl/win/red-063.exe'>https://static.red-lang.org/dl/win/red-063.exe</a>}
    .text: {Preferably install <a href='https://code.visualstudio.com/'>VSCode</a> with <a href='https://marketplace.visualstudio.com/items?itemName=red-auto.red'>&#82;ed extension</a>}
    .text: {<br>on Windows, run this command for VSCode to be able to run &#82;ed in terminal:}
    .quote: {red.exe --cli}
    .text: {If ever you have only notepad, launch  &#82;ed and type:}
    .code: {
cd %your-project/path
do %learn-khmer.red
    }

    .sub-title: {Step 4. Run your build script created :}
    .text: {Under VSCode, Right-Click and select:}
    .quote: {Run &#82;ed Script}
    .text: {or press Key:}
    .quote: {F6}

    .sub-title: {Step 5. Check outputs:}
    .text: {The output files should contain:}
    .image: %img/getting-started.png
]

Faq: [
    .title: {Faq}
    .sub-title: {How to add a subscription form}
    .text: {for example, add mailchimp code snippet}
    .code: {
&#x3C;script type=&#x22;text/javascript&#x22; src=&#x22;//downloads.mailchimp.com/js/signup-forms/popup/unique-methods/embed.js&#x22; data-dojo-config=&#x22;usePlainJson: true, isDebug: false&#x22;&#x3E;&#x3C;/script&#x3E;&#x3C;script type=&#x22;text/javascript&#x22;&#x3E;window.dojoRequire([&#x22;mojo/signup-forms/Loader&#x22;], function(L) { L.start({&#x22;baseUrl&#x22;:&#x22;mc.us20.list-manage.com&#x22;,&#x22;uuid&#x22;:&#x22;363b40a4db743ba4ef5a555a3&#x22;,&#x22;lid&#x22;:&#x22;f99b32278c&#x22;,&#x22;uniqueMethods&#x22;:true}) })&#x3C;/script&#x3E;
    }
    .text: {just create a text block with your script inside:}
    .code: {
.text: {
&#x3C;script type=&#x22;text/javascript&#x22; src=&#x22;//downloads.mailchimp.com/js/signup-forms/popup/unique-methods/embed.js&#x22; data-dojo-config=&#x22;usePlainJson: true, isDebug: false&#x22;&#x3E;&#x3C;/script&#x3E;&#x3C;script type=&#x22;text/javascript&#x22;&#x3E;window.dojoRequire([&#x22;mojo/signup-forms/Loader&#x22;], function(L) { L.start({&#x22;baseUrl&#x22;:&#x22;mc.us20.list-manage.com&#x22;,&#x22;uuid&#x22;:&#x22;363b40a4db743ba4ef5a555a3&#x22;,&#x22;lid&#x22;:&#x22;f99b32278c&#x22;,&#x22;uniqueMethods&#x22;:true}) })&#x3C;/script&#x3E;    
}
    }
]

Subscribe: [
    .title: {Subscribe to our mailing list}
    .sub-title: {To receive update news once a month}
    .text: {Just click below:
    <br><br><button id='open-popup' style='background:red;color: white;cursor:pointer;font-size: 14px;text-align: center;text-decoration: none;border: none;border-radius: 3px;padding: 13px 32px;font-family:Helvetica Neue,Arial,Helvetica,Verdana,sans-serif' >Subscribe to our mailing list</button>
    }
    note: {below is to insert subscription form:}
    .text: {
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>

<script type="text/javascript" src="//s3.amazonaws.com/downloads.mailchimp.com/js/signup-forms/popup/embed.js" data-dojo-config="usePlainJson: true, isDebug: false"></script>

<script>
function showMailingPopUp() {
    require(["mojo/signup-forms/Loader"], function(L) { L.start({"baseUrl":"mc.us20.list-manage.com","uuid":"363b40a4db743ba4ef5a555a3","lid":"f99b32278c"}) })
    document.cookie = "MCPopupClosed=; expires=Thu, 01 Jan 1970 00:00:00 UTC";
};

document.getElementById("open-popup").onclick = function() {showMailingPopUp()};
</script>
    }
]