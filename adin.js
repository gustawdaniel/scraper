const {Builder, By, Key, until} = require('selenium-webdriver');

let driver = new Builder()
    .forBrowser('chrome')
    .build();

driver.get('http://www.adin.pl/dodaj_ogloszenie/');

driver.findElement(By.id('category1')).click();
driver.sleep(200);
driver.findElement(By.css('#category1 option:nth-child(11)')).click();
driver.sleep(500);
driver.findElement(By.id('poddzial1')).click();
driver.sleep(200);
driver.findElement(By.css('#poddzial1 option:nth-child(2)')).click();
driver.sleep(200);
driver.findElement(By.id('kategoria1')).click();
driver.sleep(200);
driver.findElement(By.css('#kategoria1 option:nth-child(2)')).click();
driver.sleep(200);
driver.findElement(By.id('typ1')).click();
driver.sleep(200);
driver.findElement(By.css('#typ1 option:nth-child(2)')).click();

driver.findElement(By.css('#title')).sendKeys('Title');
driver.findElement(By.css('#desc')).sendKeys('Description Description Description Description Description Description ');

// Upload file impossible even by hand
// this is flash...
//
// ...
//
// <div id="gcUploadButton">
//     <object id="SWFUpload_0" type="application/x-shockwave-flash" data="scripts/swfupload.swf?preventswfcaching=1511821591985" class="swfupload" width="130" height="22"><param name="wmode" value="transparent"><param name="movie" value="scripts/swfupload.swf?preventswfcaching=1511821591985"><param name="quality" value="high"><param name="menu" value="false"><param name="allowScriptAccess" value="always"><param name="flashvars" value="movieName=SWFUpload_0&amp;uploadURL=%2Fdodaj_ogloszenie%2Fupload.php&amp;useQueryString=false&amp;requeueOnError=false&amp;httpSuccess=&amp;assumeSuccessTimeout=0&amp;params=PHPSESSID%3Dk3lfuafcgiq69sc1halnmdon10&amp;filePostName=Filedata&amp;fileTypes=*.jpg%3B*.jpeg%3B*.png%3B*.gif&amp;fileTypesDescription=Zdj%C4%99cia&amp;fileSizeLimit=1%20MB&amp;fileUploadLimit=0&amp;fileQueueLimit=0&amp;debugEnabled=false&amp;buttonImageURL=%2Fdodaj_ogloszenie%2F&amp;buttonWidth=130&amp;buttonHeight=22&amp;buttonText=%3Cspan%20class%3D%22button%22%3EDodaj%20zdj%C4%99cie%3C%2Fspan%3E&amp;buttonTextTopPadding=5&amp;buttonTextLeftPadding=18&amp;buttonTextStyle=.button%20%7B%20font-family%3A%20verdana%3B%20font-weight%3A%20bold%3B%20font-size%3A%2012pt%3B%20%7D&amp;buttonAction=-110&amp;buttonDisabled=false&amp;buttonCursor=-2"></object>
//     </div>

// driver.executeScript(function () {
//     document.querySelector('#category1').value = '3770';
// });

driver.sleep(7000);
driver.quit();
