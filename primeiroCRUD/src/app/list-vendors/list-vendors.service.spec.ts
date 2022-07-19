import { TestBed } from '@angular/core/testing';

import { ListVendorsService } from './list-vendors.service';

describe('ListVendorsService', () => {
  let service: ListVendorsService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ListVendorsService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
