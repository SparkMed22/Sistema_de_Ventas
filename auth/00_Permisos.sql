CREATE LOGIN UsuarioVentas WITH PASSWORD = 'VentasPassword123!';
CREATE USER UsuarioVentas FOR LOGIN UsuarioVentas;

-- Usuario 2: Encargado de Inventario y Depósitos
CREATE LOGIN UsuarioDeposito WITH PASSWORD = 'DepositoPassword123!';
CREATE USER UsuarioDeposito FOR LOGIN UsuarioDeposito;

GRANT SELECT, INSERT, UPDATE, DELETE ON Cliente TO UsuarioVentas;
GRANT SELECT, INSERT, UPDATE, DELETE ON VentaCabecera TO UsuarioVentas;
GRANT SELECT, INSERT, UPDATE, DELETE ON VentaDetalle TO UsuarioVentas;
GRANT SELECT, INSERT, UPDATE, DELETE ON CobroCabecera TO UsuarioVentas;
GRANT SELECT, INSERT, UPDATE, DELETE ON CobroDetalle TO UsuarioVentas;

DENY INSERT, UPDATE, DELETE ON Deposito TO UsuarioVentas;
DENY INSERT, UPDATE, DELETE ON Inventario TO UsuarioVentas;
DENY INSERT, UPDATE, DELETE ON TransferenciaCabecera TO UsuarioVentas;
DENY INSERT, UPDATE, DELETE ON TransferenciaDetalle TO UsuarioVentas;

GRANT SELECT ON Producto TO UsuarioVentas;
GRANT SELECT ON Inventario TO UsuarioVentas;


GRANT SELECT, INSERT, UPDATE, DELETE ON Deposito TO UsuarioDeposito;
GRANT SELECT, INSERT, UPDATE, DELETE ON Inventario TO UsuarioDeposito;
GRANT SELECT, INSERT, UPDATE, DELETE ON TransferenciaCabecera TO UsuarioDeposito;
GRANT SELECT, INSERT, UPDATE, DELETE ON TransferenciaDetalle TO UsuarioDeposito;
GRANT SELECT, INSERT, UPDATE, DELETE ON Producto TO UsuarioDeposito;

DENY INSERT, UPDATE, DELETE ON Cliente TO UsuarioDeposito;
DENY INSERT, UPDATE, DELETE ON VentaCabecera TO UsuarioDeposito;
DENY INSERT, UPDATE, DELETE ON VentaDetalle TO UsuarioDeposito;
DENY INSERT, UPDATE, DELETE ON CobroCabecera TO UsuarioDeposito;
DENY INSERT, UPDATE, DELETE ON CobroDetalle TO UsuarioDeposito;
GRANT SELECT ON Cliente TO UsuarioDeposito;