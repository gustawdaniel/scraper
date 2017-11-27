const {Builder, By, Key, until} = require('selenium-webdriver');

let driver = new Builder()
    .forBrowser('chrome')
    .build();

driver.get('http://www.lento.pl/dodaj-ogloszenie.html');
driver.findElement(By.id('adtitle')).sendKeys('webdriver');
driver.findElement(By.id('select-subcatid')).click();
driver.findElement(By.id('#select-subcatid option:nth-child(3)')).click();
// driver.click('#select-subcatid').click('#select-subcatid option:nth-child(3)');
driver.sleep(5000);
driver.quit();

