const {Builder, By, Key, until} = require('selenium-webdriver');

let driver = new Builder()
    .forBrowser('firefox')
    .build();

driver.get('http://warszawa.oglaszamy24.pl/dodaj-ogloszenie2.php?c1=2&c2=22&at=1');

// driver.sleep(3000);

driver.findElement(By.id('ad_title')).sendKeys('Title');
driver.findElement(By.id('desc')).sendKeys('Description Description Description Description Description Description Description Description Description Description');
driver.findElement(By.id('price')).sendKeys('200');

upload = driver.findElement(By.id("filename"));
upload.sendKeys("/home/daniel/pro/scraper/example.png");

driver.findElement(By.id('contact_name')).sendKeys('Adam Testowy');
driver.findElement(By.id('phone')).sendKeys('132123132');
driver.findElement(By.id('email')).sendKeys('example@ok.pl');
// driver.findElement(By.id('agree')).click();

// driver.findElement(By.css("input[type=submit]")).click();

driver.sleep(7000);
driver.quit();

