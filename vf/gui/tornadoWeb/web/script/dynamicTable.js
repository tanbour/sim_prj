
//var Global Assigment
var numStream = 0;
//var privateListArr = new Array();

//add one row in the current table
function addInstanceRow(tableId) {
	var tableObj = getTargetControl(tableId);
	var tbodyOnlineEdit = getTableTbody(tableObj);
	var theadOnlineEdit = tableObj.getElementsByTagName("tbody")[0];
	var elm = theadOnlineEdit.rows[theadOnlineEdit.rows.length - 1].cloneNode(true);
	//alert(theadOnlineEdit.rows.length-1);
	numStream++;
	elm.style.display = "";
	elm.cells[0].innerHTML = numStream;


	tbodyOnlineEdit.appendChild(elm);
	//alert(numStream);
}

//得到table中的tbody控件，注意兼容firefox
function getTableTbody(tableObj) {
	var tbodyOnlineEdit = tableObj.getElementsByTagName("tbody")[0];
	if (typeof (tbodyOnlineEdit) == "undefined" || tbodyOnlineEdit == null) {
		tbodyOnlineEdit = document.createElement("tbody");
		tableObj.appendChild(tbodyOnlineEdit);
	}

	return tbodyOnlineEdit;
}


//删除触发事件控件所在的行
function deleteThisRow(targetControl) {
	if (targetControl.tagName == "TR")
		targetControl.parentNode.removeChild(targetControl);
	else
		deleteThisRow(targetControl.parentNode);
}

//删除最后控件所在的行
function deleteEndRow(ethPckTable) {
	var tableObj = document.getElementById(ethPckTable);
	var theadOnlineEdit = tableObj.getElementsByTagName("tbody")[0];
	var rowCur = theadOnlineEdit.rows[parseInt(numStream) + 1];

	//if(Trim(rowCur.tagName)=="TR"){
	if ((rowCur.tagName == "TR") && (parseInt(numStream) > 0)) {
		//alert(rowCur.tagName);
		rowCur.parentNode.removeChild(rowCur);
	}
	else {
		alert("error when try to delete the last Row");
	}

	numStream--;
}



function detailShow(selfOwn) {
	//(1) Judge whether is the detail header
	if (matchString("detail", selfOwn.innerHTML) == true) {
		//selfOwn.style.display='none'; // first close the detail header
		//(1)获取当前处理的tr行对象
		var trObj = selfOwn.parentNode;
	}
	else {
		//(1)获取当前处理的tr行对象
		var trObj = selfOwn.parentNode.parentNode.parentNode;
		//alert(trObj);
	}
	//(2) 提取当前的选项编号，比如 [1] L2 1588,那么提取编号为1
	var td1Obj = trObj.cells[1];
	var td1SelectObj = filterTextChildNodes(td1Obj);
	var re = /\d+\s*\]/; //通配符 数字] 这种样式
	var arr = re.exec(td1SelectObj.value);
	var optValue = arr[0].replace(/\s*\]/g, "");
	//alert(optValue);
	//(2)获取当前要显示的td对象
	var j = 2 + parseInt(optValue);
	var tdCurObj = trObj.cells[j];
	//(3)关闭所有之前打开的td内容,除了当前处理的td
	for (var i = 2; i < trObj.cells.length; i++) {
		if (i != j)
			trObj.cells[i].style.display = 'none';
	}
	//(4)如果之前没打开，就打开它，如果之前打开了就关闭它
	if (tdCurObj.style.display == 'none') {
		tdCurObj.style.display = '';
		//alert(trObj.cells[0].bgColor);
		trObj.cells[0].bgColor = "#D8D8BF";//麦绿色
		trObj.cells[1].bgColor = "#D8D8BF";//麦绿色
		trObj.cells[2].bgColor = "#D8D8BF";//麦绿色

	}
	else {
		tdCurObj.style.display = 'none';
		trObj.cells[2].style.display = ''; //打开detail
	}
}

function detailShow1(ethPckTable, numStream, pckType, self) {
	var tableObj = document.getElementById(ethPckTable);
	var theadOnlineEdit = tableObj.getElementsByTagName("tbody")[0];
	var rowCur = theadOnlineEdit.rows[parseInt(numStream) + 1];

	//(1) Judge whether is the detail header
	if (matchString("detail", self.innerHTML) == true) {
		self.style.display = 'none'; // first close the detail header
	}
	//(2) display the packet detail
	switch (pckType) {
		case "[1] l2pdu1588":
			if (rowCur.cells[3].style.display == 'none') {
				rowCur.cells[3].style.display = '';
			}
			else {
				rowCur.cells[3].style.display = 'none';
				self.parentNode.cells[2].style.display = ''; //display the detail header
			}
			rowCur.cells[4].style.display = 'none';
			break;
		case "[2] l3pdu1588":

			if (rowCur.cells[4].style.display == 'none') {
				rowCur.cells[4].style.display = '';
			}
			else {
				rowCur.cells[4].style.display = 'none';
				self.parentNode.cells[2].style.display = ''; //display the detail header
			}
			rowCur.cells[3].style.display = 'none';
			break;
		default:
			rowCur.cells[3].style.display = 'none';
			rowCur.cells[4].style.display = 'none';
			self.parentNode.cells[2].style.display = ''; //display the detail header
			break;
	}
}

function publicTableShow(ethPublicPckTableId) {
	tableObj = getTargetControl(ethPublicPckTableId);
	var tableRow = tableObj.getElementsByTagName('tr');
	for (var i = 1; i < tableRow.length; i++) {
		if (tableRow[i].style.display == '') //if it was opened ,then ,closed it
			tableRow[i].style.display = 'none';
		else
			tableRow[i].style.display = '';
	}
}





function show(abc) {
	//alert(abc);
}
//// 对于firefox而言，过滤到空行和注释等等信息
function filterTextChildNodes(parentNodeCur) {
	var i = 0;
	while ((parentNodeCur.childNodes[i].nodeName == "#text") ||
		(parentNodeCur.childNodes[i].nodeName == "#comment")
	) {
		i++;
	}
	return parentNodeCur.childNodes[i];
}
//得到指定的控件
//假如传递的是控件，得返回控件
//假如传递的是ID值，则自动查找出控件并返回
function getTargetControl(targetControl) {
	if (typeof (targetControl) == "string") {
		return document.getElementById(targetControl);
	}
	else return targetControl;
}
//去除空格
function Trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function publicTableCheck(ethPublicPckTableId) {
	//alert('xxx');
	tableObj = getTargetControl(ethPublicPckTableId);
	var tableRow = tableObj.getElementsByTagName('tr');
	var valueTmp = filterTextChildNodes(tableRow[1].cells[2]);

	//去掉空格
	valueTmp.value = Trim(valueTmp.value);
	//判断是否是10进制数
	decimalCheck(valueTmp.value);

	//转换成16进制
	var decValue = parseInt(valueTmp.value);
	decValue = decValue.toString(16);
	//alert(decValue);
	decValue1 = transformHexBytes(4, decValue)


	//10进制转换成16进制
	//alert(valueTmp.value.toString(16));

	//valueTmp.value +=1;
	//alert( filterTextChildNodes(tableRow[1].cells[2]) );
}
////将16进制数转换成字节形式
////比如 0x123,如果转换成4Byte，则为00 00 01 23
function transformHexBytes(numBytes, valueHexInput) {
	//alert("fuck");
	//alert(valueHexInput);
	var valueHexInputLength = valueHexInput.length;
	var numBytesDouble = numBytes * 2;
	if (valueHexInputLength > numBytesDouble) {
		//alert("填充的字节数过小，或者要转换的数字过大");
		alert("numBytes too small or HexInput too big");
		return 0;
	}
	else {
		////(1)将输入字符串高位用0补齐
		////比如原来是0x13f,需要4BYTE，则补齐成0000013f
		var valueHexArr1 = new Array();
		var j = 0;
		for (var i = 0; i < numBytesDouble; i++) {
			if (i < (numBytesDouble - valueHexInputLength)) {
				valueHexArr1[i] = "0";
			}
			else {
				valueHexArr1[i] = valueHexInput[j];
				j++;
			}
		}
		////(2)字节之间用空格分开
		////比如原来是0000013f 分开后成为00 00 01 3f
		var valueHexOutputLength = numBytes * 3;
		var valueHexArr2 = new Array();
		var k = 0;
		var j = 0;
		for (var i = 0; i < valueHexOutputLength; i++) {
			if (j == 2) {
				valueHexArr2[i] = ' ';
				j = 0;
			}
			else {
				valueHexArr2[i] = valueHexArr1[k];
				k++;
				j++;
			}
		}
		////(3)将字符串数组转换成字符串
		var valueHexOutput = valueHexArr2.join();
		////(4)转换后，原来数组内元素有很多“,”，因此需要去除逗号
		//// 执行替换，将逗号替换成空
		valueHexOutput = valueHexOutput.replace(/,/g, "");
		//valueHexOutput+=valueHexInput;
		//alert(valueHexOutput);
		return valueHexOutput;
	}

}

function loadPublicPck(publicTableArr){
	var publicTableObj = getTargetControl(ethPublicPckTable);
	var publicRows = publicTableObj.getElementsByTagName('tr');
	// alert(publicTableArr[2]);
	for (var i = 1; i < publicRows.length; i++) {
		var inputTxt = filterTextChildNodes(publicRows[i].cells[2]);
		inputTxt.value = publicTableArr[i-1]; 
	}
}

function loadPrivatePck(privateTableArr){
	var privateTableObj = getTargetControl("ethPrivatePckTable");
	var privateTbodyObj = privateTableObj.getElementsByTagName("tbody")[0];
	//alert("numStream="+numStream);
	////从2开始，因为0行：表头，1:隐藏的复制行，2才是真正行
	for (var i = 2; i < (parseInt(privateTableArr.length) + 2); i++) {
		addInstanceRow("ethPrivatePckTable");
		////initial jsonPrivateArr
		////(2)寻找到下拉选项控件
		var selectNode = filterTextChildNodes(privateTbodyObj.rows[i].cells[1]);
		var re = /\d+\s*\]/;
		var arr = re.exec(selectNode.value);
		////(2.1)寻找到下拉选项控件的索引值
		var optValue = arr[0].replace(/\]/g, "");
		// set the selectNode value
		////(2.2)通过索引值，找到表内容对应的子表格
		var optTable = filterTextChildNodes(privateTbodyObj.rows[i].cells[2 + parseInt(optValue)]);
		//alert(optTable);
		////(2.3)处理子表格的每一行，以数组形式处理
		var optTrArr = optTable.getElementsByTagName('tr');
		////(4)处理表格主体部分
		for (var k = 1; k < optTrArr.length; k++) {
			//(4.1)取描述行的原始内容
			var inputTxt = filterTextChildNodes(optTrArr[k].cells[1]);
			//(4.3.1)set the value to jsonPrivateArr;
			inputTxt.value = privateTableArr[i-2][k]; 
		}
	}

}

function initLoad() {
	//get the data from json file on the web server
	$.ajax({
		type: "GET", url: "/config",
		// contentType: "application/json;charset=utf-8", 
		data: {
			json:$("#json").val()
		} , 
		dataType: "json", success: function (message) { 
			//alert("load successful\n"+JSON.stringify(message));
			var publicTableArr = JSON.parse(message.message.ethPublicPckTable);
			loadPublicPck(publicTableArr);
			var privateTableArr = JSON.parse(message.message.ethPrivatePckTable);
			//alert(privateTableArr.length);
			loadPrivatePck(privateTableArr);
		 }, error: function (message) { 
			alert("load failed\n"+JSON.stringify(message));
		}
	});
}

function submitRun(cfgFilePathId, ethPublicPckTableId, ethPrivatePckTableId) {
	var filePathObj = getTargetControl(cfgFilePathId);
	var filePath = filePathObj.value;
	var contentArr = new Array();
	var jsonPublicArr = new Array();
	var jsonPrivateArr = new Array();

	////(1)(Public Stream Write)
	var publicTableObj = getTargetControl(ethPublicPckTableId);
	var publicRows = publicTableObj.getElementsByTagName('tr');
	//alert(publicRows.length);
	contentArr[0] = "//===============================================================================================//";
	contentArr[1] = "//****";
	contentArr[2] = "//Public Stream Configuration ";
	contentArr[3] = contentArr[1];
	contentArr[4] = contentArr[0];
	contentArr[5] = "//Public Stream address";
	contentArr[6] = "@0000";
	var j = 7;
	//alert(publicRows[1].cells[1].innerHTML);
	//var inputTxt;

	for (var i = 1; i < publicRows.length; i++) {
		////(1)取描述行的原始内容
		contentArr[j] = publicRows[i].cells[1].innerHTML;
		////(2)提取描述内容中[\d+B]部分，比如[4B]，则取出4
		var re = /(\d+\s*B\s*\])/;
		var arr = re.exec(contentArr[j]);
		//alert(arr[1]);
		var numBytes = arr[1].replace(/B\]/g, "");
		//alert(numBytes);
		////(3)过滤掉注释、空格等文本节点
		var inputTxt = filterTextChildNodes(publicRows[i].cells[2]);
		////(3.1)set the jsonPublicArr
		jsonPublicArr[i-1] = inputTxt.value;
		//// update innerHtml
		publicRows[i].cells[2].setAttribute("value",55);
		//alert(publicRows[i].cells[2].innerHTML);
		//alert(publicRows[i].cells[2].innerHTML);
		////publicRows[i].cells[2].innerHTML = inputTxt.value;
		////(4)去除空格
		inputTxt.value = Trim(inputTxt.value);
		//alert(inputTxt.value);
		////(5)判断是否是10进制数
		decimalCheck(contentArr[j], inputTxt.value);
		////(6)装载新的注释信息，添加了数值
		contentArr[j] = "//==" + contentArr[j] + " = " + inputTxt.value;
		////(7)转换成10进制
		var decValue = parseInt(inputTxt.value);
		////(8)转换成16进制
		var hexValue = decValue;
		hexValue = hexValue.toString(16);
		//alert(hexValue);
		////(9)按字节格式生成成要写入的字符串		
		var outputTxt = transformHexBytes(numBytes, hexValue);
		//alert(outputTxt);
		contentArr[j + 1] = outputTxt;
		//alert(contentArr[j+1]);
		j = j + 2;
	}
	var priPt = j;
	////(2)(Private Stream Write)
	var privateTableObj = getTargetControl(ethPrivatePckTableId);
	var privateTbodyObj = privateTableObj.getElementsByTagName("tbody")[0];

	if (numStream < 1) {
		alert("The numStream is less than 1,Error!!");
	}
	//alert("numStream="+numStream);
	var j = priPt;
	////从2开始，因为0行：表头，1:隐藏的复制行，2才是真正行
	for (var i = 2; i <= (parseInt(numStream) + 1); i++) {
		////initial jsonPrivateArr
		jsonPrivateArr[i-2] = new Array();
		////(1)生成表头信息
		//(1.1)寻找当前流编号
		var numStreamCur = privateTbodyObj.rows[i].cells[0].innerHTML;
		//(1.2)去除空格
		numStreamCur = Trim(numStreamCur);
		//(1.3)生成流的基地址
		var numStreamDec = parseInt(numStreamCur);
		var numStreamAddr = numStreamDec * 1024;
		var hexAddr = numStreamAddr;
		hexAddr = hexAddr.toString(16);
		////(2)寻找到下拉选项控件
		var selectNode = filterTextChildNodes(privateTbodyObj.rows[i].cells[1]);
		var re = /\d+\s*\]/;
		var arr = re.exec(selectNode.value);
		////(2.1)寻找到下拉选项控件的索引值
		var optValue = arr[0].replace(/\]/g, "");
		// set the selectNode value
		jsonPrivateArr[i-2][0] = optValue;
		////(2.2)通过索引值，找到表内容对应的子表格
		var optTable = filterTextChildNodes(privateTbodyObj.rows[i].cells[2 + parseInt(optValue)]);
		//alert(optTable);
		////(2.3)处理子表格的每一行，以数组形式处理
		var optTrArr = optTable.getElementsByTagName('tr');

		////(3)初始化每条流的表头
		contentArr[j] = contentArr[0];
		contentArr[j + 1] = contentArr[1];
		contentArr[j + 2] = "//==NO." + numStreamCur + " Stream " + selectNode.value;
		contentArr[j + 3] = contentArr[1];
		contentArr[j + 4] = contentArr[0];
		contentArr[j + 5] = "//==Private Stream address";
		contentArr[j + 6] = "@" + hexAddr;//Stream Address
		//alert(contentArr[j+6]);
		j = j + 7;
		//alert("optTrArr.length="+optTrArr.length);
		////(4)处理表格主体部分
		for (var k = 1; k < optTrArr.length; k++) {
			//(4.1)取描述行的原始内容
			contentArr[j] = optTrArr[k].cells[0].innerHTML;
			//(4.2)提取描述内容中[\d+B]部分，比如[4B]，则取出4
			var re = /(\d+\s*B\s*\])/;
			var arr = re.exec(contentArr[j]);
			var numBytes = arr[1].replace(/B\]/g, "");
			//decimalCheck(contentArr[j+2]+"numBytes",numBytes);
			//alert(numBytes);
			//(4.3)过滤掉注释、空格等文本节点
			var inputTxt = filterTextChildNodes(optTrArr[k].cells[1]);
			//(4.3.1)set the value to jsonPrivateArr;
			jsonPrivateArr[i-2][k] = inputTxt.value; 
			//(4.4)去除空格;
			inputTxt.value = Trim(inputTxt.value);
			//alert(contentArr[j]+inputTxt.value);
			//(4.5)判断是否是按字节形式的16进制数，比如0x12f 显示01 2f
			hexCheck("Stream No." + numStreamCur + contentArr[j], inputTxt.value, numBytes);
			//(4.6)装载新的注释信息，添加了数值
			contentArr[j] = "//==" + k + contentArr[j];
			//(4.7)去除多余的空格,方便书写
			contentArr[j] = contentArr[j].replace(/\s+/g, " ");
			//var numBytes=arr[1].replace(/B\]/g,"");
			var hexValue = inputTxt.value;
			//(4.8)装载内容
			contentArr[j + 1] = hexValue;
			j += 2;
		}
	}
	////(3)(WriteFile from contentArr)
	//writeFile(filePath,contentArr); // No connect the web server 
	// Connect the web server
	var arrString=JSON.stringify(contentArr); 
	var jsonPublicString=JSON.stringify(jsonPublicArr);
	var jsonPrivateString=JSON.stringify(jsonPrivateArr);
	$.ajax({
		type: "POST", url: "/config",
		// contentType: "application/json;charset=utf-8", 
		data: {
			"path":filePath,
			"name":arrString,
			"jsonPublic":jsonPublicString,
			"jsonPrivate":jsonPrivateString
		} , 
		dataType: "json", success: function (message) { 
			alert("submit successful"+JSON.stringify(message));
		 }, error: function (message) { 
			alert("submit failed"+JSON.stringify(message));
		}
	});
}

function decimalCheck(strNote, strValue) {

	var re = /^\s*\d+\s*$/;
	if (re.test(strValue) != true) {
		alert("decimalCheck" + strNote + "Failed");
	}
	//alert(re.test(strValue)) ;
}


function hexCheck(strNote, strValue, numBytes) {


	//====(1) step delete the multi space 
	//==consider 1 "13    34"
	//==in order to calculate the length of the string.
	//==we should delete the multi space 
	//==so consider 1 "13    34" change to "13 34" 
	strValue = strValue.replace(/\s+/g, " ");
	//====(2) step
	//==consider 1 "12" 
	//==consider 2 "2f f5"
	//==the right side is no space,so add the space
	//==in order to easy to match the rule
	//==so consider 1 "1 12" change to "01 12 "
	//==so consider 2 "2f f5" change to "2f f5 "
	strValue += ' ';
	//====(3) step calculate the length of the string
	if (strValue.length != (numBytes * 3)) {
		alert("hexCheck" + strNote + strValue + "length error Failed");
	}
	//====(4) step check whether the pattern ok or not 
	//“{2}“表示前面的标记组，仅能出现2次
	//var re= /^\s*([a-fA-F0-9][a-fA-F0-9]\s+)+\s*$/;
	var re = /^\s*([a-fA-F0-9]{2}\s+)+\s*$/;
	if (re.test(strValue) != true) {
		alert("hexCheck" + strNote + strValue + "Failed");
	}
}

//正则表达式，匹配变量的值
//matchKey是变量，存放的值是变量inStr要去匹配的值
//如果inStr内部包含matchKey的值，那么匹配成功，
//返回1,否则返回0
function matchString(matchKey, inStr) {
	//如果用变量matchKey,必须使用new RegExp()的方法，
	//并且里面的字符串没有那个反斜杠，因此用了|的方法
	//re = new RegExp('(\\s|^)' + matchKey + '(\\s|$)');
	re = new RegExp(matchKey);
	return (re.test(inStr));
}

function detailTdShow(tdObj, matchKey) {
	//过滤掉空格
	tdObj.style.color = Trim(tdObj.style.color);
	//(1)改变颜色
	if (tdObj.style.color == 'blue') {
		tdObj.style.color = 'green';
	}
	else {
		tdObj.style.color = 'blue';
	}
	//(2)
	var parentTable = tdObj.parentNode.parentNode;

	var trArr = parentTable.getElementsByTagName('tr');

	for (var i = 1; i < trArr.length; i++) {
		if (matchString(matchKey, trArr[i].innerHTML) == true) {
			//==(1)去掉首尾空格
			//trArr[i].style.display=Trim(trArr[i].style.display);
			if (trArr[i].style.display == '')
				trArr[i].style.display = 'none';
			else
				trArr[i].style.display = '';
		}
	}

	tdObj.parentNode.style.display = '';
	/*
	var inStr = "asd王秋超   vlan word medm xxafasdfasdf"
	//var matchKey
	var matchResult = matchString(matchKey,inStr);
	alert(matchResult);
	//alert(buttonObj.parentNode);
	*/
}

function updateCfgFilePath(selfObj, cfgFilePathId) {
	var cfgObj = getTargetControl(cfgFilePathId);
	//cfgObj.value = cfgObj.value.replace(/tc\d+w+\//,selfObj.value);
	var cfgValue = cfgObj.value;
	cfgObj.value = cfgValue.replace(/tc\d+\w+\//, selfObj.value + '/');
	alert(cfgObj.value);
	//var optValue=arr[0].replace(/\s*\]/g,"");
	//alert(selfObj.value);
}

function writeFile(filePath, contentArr) {
	//var filePath = "test.dat";  
	//var stringContent = "Hell0";  
	try {
		netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
	} catch (e) {
		alert("no permisson...");
	}
	var file = Components.classes["@mozilla.org/file/local;1"].createInstance(Components.interfaces.nsILocalFile);
	file.initWithPath(filePath);
	if (file.exists() == false) {
		file.create(Components.interfaces.nsIFile.NORMAL_FILE_TYPE, 420);
	}
	var outputStream = Components.classes["@mozilla.org/network/file-output-stream;1"].createInstance(Components.interfaces.nsIFileOutputStream);
	outputStream.init(file, 0x04 | 0x08 | 0x20, 420, 0);
	var converter = Components.classes["@mozilla.org/intl/scriptableunicodeconverter"].createInstance(Components.interfaces.nsIScriptableUnicodeConverter);
	converter.charset = 'UTF-8';
	for (var i = 0; i < contentArr.length; i++) {
		var convSource = converter.ConvertFromUnicode(contentArr[i] + "\n");
		var result = outputStream.write(convSource, convSource.length);
	}
	outputStream.close();
	alert("File was saved in " + filePath);
}

//读取本地文件  
function readFile(path) {
	try {
		netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
	} catch (e) {
		alert("Permission to read file was denied.");
	}
	var file = Components.classes["@mozilla.org/file/local;1"]
		.createInstance(Components.interfaces.nsILocalFile);
	file.initWithPath(path);
	if (file.exists() == false) {
		alert("File does not exist");
	}
	var is = Components.classes["@mozilla.org/network/file-input-stream;1"]
		.createInstance(Components.interfaces.nsIFileInputStream);
	is.init(file, 0x01, 00004, null);
	var sis = Components.classes["@mozilla.org/scriptableinputstream;1"]
		.createInstance(Components.interfaces.nsIScriptableInputStream);
	sis.init(is);
	var converter = Components.classes["@mozilla.org/intl/scriptableunicodeconverter"]
		.createInstance(Components.interfaces.nsIScriptableUnicodeConverter);
	converter.charset = "UTF-8";
	var output = converter.ConvertToUnicode(sis.read(sis.available()));
	return output;
}






