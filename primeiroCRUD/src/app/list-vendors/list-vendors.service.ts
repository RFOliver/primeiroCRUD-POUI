import { HttpClient, HttpHeaders  } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { PoTableColumn } from '@po-ui/ng-components';
import { Observable } from 'rxjs/internal/Observable';

@Injectable({
  providedIn: 'root'
})
export class ListVendorsService {

  ApiURL = 'http://k1qrd5.hom.protheus.totvscloud.com.br:24487/api/primeiroCrud/todos'
  authorizationData = 'Basic ' + btoa('usrfso:123456');
  
  headerOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': this.authorizationData
    })
  };

  constructor(private http: HttpClient) { }

  //Metodo que irá executar a URL e retornar todos os fornecedores
  getVendorList(): Observable<any> {
    
    return this.http.get(this.ApiURL , this.headerOptions )
  }

  getColumns(): Array<PoTableColumn> {
    return[
      {property: 'codigo' , label: 'Código'},
      {property: 'loja' , label: 'Loja'}
    ]
  }
}
