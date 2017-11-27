const {Builder, By, Key, until} = require('selenium-webdriver');

let driver = new Builder()
    .forBrowser('chrome')
    .build();

driver.get('http://www.lento.pl/dodaj-ogloszenie.html');

driver.findElement(By.id('adtitle')).sendKeys('webdriver');

driver.findElement(By.id('select-subcatid')).click();
driver.findElement(By.css('#select-subcatid option:nth-child(13)')).click();
driver.findElement(By.id('select-subcatid')).click();

driver.findElement(By.css('input[name=atrr_6_2]')).sendKeys('50');

driver.findElement(By.id('atrr_6_3')).click();
driver.findElement(By.css('#atrr_6_3 option:nth-child(3)')).click();
driver.findElement(By.id('atrr_6_3')).click();

driver.findElement(By.id('addesc')).sendKeys('Description');

upload = driver.findElement(By.css("input[type=file]"));
upload.sendKeys("/home/daniel/pro/scraper/example.png");

driver.findElement(By.id('location')).sendKeys('Warszawa');
driver.sleep(200);
driver.findElement(By.css('ul#ui-id-1 li a')).click();

driver.findElement(By.id('email')).sendKeys('example@ok.pl');
driver.findElement(By.id('surname')).sendKeys('Adam Testowy');
driver.findElement(By.id('agree')).click();

driver.findElement(By.css("input[type=submit]")).click();

driver.sleep(7000);
driver.quit();

