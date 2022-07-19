import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { PoModule } from '@po-ui/ng-components';
import { RouterModule } from '@angular/router';
import { PoTemplatesModule } from '@po-ui/ng-templates';
import { PoNotificationModule  } from '@po-ui/ng-components';
import { PoDynamicModule } from '@po-ui/ng-components';
import { PoButtonModule } from '@po-ui/ng-components';

import { ListVendorsComponent } from './list-vendors/list-vendors.component'

@NgModule({
  declarations: [
    AppComponent,
    ListVendorsComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    PoModule,
    RouterModule.forRoot([]),
    PoTemplatesModule,
    PoNotificationModule,
    PoDynamicModule,
    PoButtonModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
