// email: nabeel.novak@oou.us

const {Builder, By, Key, until} = require('selenium-webdriver');

let driver = new Builder()
    .forBrowser('chrome')
    .build();

driver.get('https://www.olx.pl/konto/?ref%5B0%5D%5Bparams%5D%5Bbs%5D=homepage_adding&ref%5B0%5D%5Baction%5D=adding&ref%5B0%5D%5Bmethod%5D=index');

// login
driver.findElement(By.id('userEmail')).sendKeys('nabeel.novak@oou.us');
driver.findElement(By.id('userPass')).sendKeys('passpass');
driver.findElement(By.id('se_userLogin')).click();

// simple image
driver.findElement(By.id('show-gallery-html')).click();

// category
driver.findElement(By.id('add-title')).sendKeys('Title');
driver.findElement(By.id('targetrenderSelect1-0')).click();
driver.sleep(500);
driver.findElement(By.id('cat-3')).click();
driver.sleep(500);
driver.findElement(By.css('a[data-category="1307"]')).click();
driver.sleep(300);
driver.findElement(By.css('a[data-category="15"]')).click();
driver.sleep(500);
driver.findElement(By.css('#targetparam155 a')).click();
driver.sleep(300);
driver.findElement(By.css('#targetparam155 dd ul :nth-child(2) a')).click();

driver.findElement(By.css('input[name="data[param_price][1]"]')).sendKeys('200');

driver.findElement(By.id('targetparam157')).click();
driver.sleep(300);
driver.findElement(By.css('#targetparam157 dd ul :nth-child(2) a')).click();

driver.findElement(By.id('param163')).sendKeys('200');

driver.findElement(By.id('targetparam167')).click();
driver.sleep(300);
driver.findElement(By.css('#targetparam167 dd ul :nth-child(2) a')).click();

driver.findElement(By.id('param250')).sendKeys('200');

driver.findElement(By.id('targetid_private_business')).click();
driver.sleep(300);
driver.findElement(By.css('#targetid_private_business dd ul :nth-child(2) a')).click();

driver.findElement(By.id('add-description')).sendKeys('Description Description Description Description Description Description Description Description Description');

// driver.executeScript('scroll(0, -700);');
// driver.sleep(40);

// images
upload = driver.findElement(By.css('input[name="image[1]"][type=file]'));
upload.sendKeys("/home/daniel/pro/scraper/example.png");

// place
driver.findElement(By.id('mapAddress')).sendKeys('Warszawa, Praga');
driver.sleep(500);
driver.findElement(By.css('div.autosuggest-geo-div.autosuggest-geo-adding a')).click();

// sign
driver.findElement(By.id('add-person')).sendKeys('Adam Testowy');

driver.findElement(By.css("a.cookiesBarClose.abs.close")).click();
driver.findElement(By.id("preview-link")).click();

driver.sleep(7000);
driver.quit();
