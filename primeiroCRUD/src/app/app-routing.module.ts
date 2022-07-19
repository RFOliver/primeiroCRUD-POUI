import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ListVendorsComponent } from './list-vendors/list-vendors.component'

const routes: Routes = [
  { path: '', component: ListVendorsComponent},
  { path: 'vendors', component: ListVendorsComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
