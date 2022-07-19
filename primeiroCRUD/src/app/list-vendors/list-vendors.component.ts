import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { PoNotificationService } from '@po-ui/ng-components';
import { ListVendorsService } from './list-vendors.service'

@Component({
  selector: 'app-list-vendors',
  templateUrl: './list-vendors.component.html',
  styleUrls: ['./list-vendors.component.css']
})

export class ListVendorsComponent implements OnInit {

  vendorList: Array<any> = new Array();
  tableCols: Array<any> = new Array();

  constructor(
    private ListVendorsService: ListVendorsService,
    private router: Router,
    private poNotification: PoNotificationService
  ) { }

  ngOnInit(): void {
    this.updateVendorList()
    this.tableCols = this.ListVendorsService.getColumns()
  }

  updateVendorList(): void {
    this.ListVendorsService.getVendorList().subscribe(
      response => {this.vendorList = response.fornecedores}
    )
  }

}
