## 1. Obtener la lista de todos los pedidos con los nombres de clientes usando INNER JOIN

```sql
SELECT p.id AS PedidoID, c.nombre AS ClienteNombre
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id;
```