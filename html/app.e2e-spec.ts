import { SekureProductionPage } from './app.po';

describe('sekure-production App', () => {
  let page: SekureProductionPage;

  beforeEach(() => {
    page = new SekureProductionPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
