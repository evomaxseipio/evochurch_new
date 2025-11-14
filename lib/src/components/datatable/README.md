# DataTable Component

Un componente DataTable completo, reutilizable e independiente para Flutter con paginación, ordenamiento, filtrado y búsqueda.

## 📁 Estructura

```
datatable/
├── datatable.dart                    # Widget DataTable3 base
├── paginated_data_table.dart         # Widget CustomPaginatedTable con paginación
├── datatable_component.dart          # Archivo de exportación principal
├── bloc/
│   ├── data_table_bloc.dart         # BLoC para gestión de estado
│   ├── data_table_event.dart        # Eventos del BLoC
│   └── data_table_state.dart        # Estados del BLoC
├── utils/
│   ├── responsive.dart              # Utilidades responsive
│   ├── spacing.dart                 # Utilidades de espaciado
│   └── colors.dart                  # Colores del componente
└── README.md                        # Este archivo
```

## 🚀 Instalación

### 1. Copiar el componente

Copia toda la carpeta `datatable` a tu proyecto Flutter.

### 2. Dependencias

Asegúrate de tener estas dependencias en tu `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.0
  flutter_hooks: ^0.20.0
```

### 3. Importar

```dart
import 'package:tu_proyecto/components/datatable/datatable_component.dart';
```

## 📖 Uso Básico

### Ejemplo Simple

```dart
import 'package:flutter/material.dart';
import 'package:tu_proyecto/components/datatable/datatable_component.dart';

class MyTablePage extends StatelessWidget {
  final List<MyModel> data = [...]; // Tus datos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaginatedTable<MyModel>(
        title: 'Mi Tabla',
        data: data,
        columns: [
          SortColumn(
            label: 'Nombre',
            field: 'name',
            getValue: (item) => item.name,
          ),
          SortColumn(
            label: 'Email',
            field: 'email',
            getValue: (item) => item.email,
          ),
        ],
        getCells: (item) => [
          DataCell(Text(item.name)),
          DataCell(Text(item.email)),
        ],
        filterFunction: (item, query) {
          return item.name.toLowerCase().contains(query.toLowerCase()) ||
                 item.email.toLowerCase().contains(query.toLowerCase());
        },
        actionMenuBuilder: (context, item) => [
          PopupMenuItem(
            value: 'edit',
            child: Text('Editar'),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Text('Eliminar'),
          ),
        ],
        onActionSelected: (action, item) {
          // Manejar acción
          print('Acción: $action en ${item.name}');
        },
        onRowTap: (item) {
          // Manejar tap en fila
          print('Tapped: ${item.name}');
        },
      ),
    );
  }
}
```

## 🎨 Características

### ✅ Paginación
- Navegación entre páginas
- Configuración de filas por página (default: 10)
- Indicador de registros mostrados

### ✅ Búsqueda y Filtrado
- Campo de búsqueda integrado
- Filtrado en tiempo real
- Función de filtrado personalizable

### ✅ Ordenamiento
- Ordenamiento por columnas
- Indicadores visuales de ordenamiento
- Orden ascendente/descendente

### ✅ Acciones por Fila
- Menú de acciones personalizable
- PopupMenuButton integrado
- Callbacks para acciones

### ✅ Botones Personalizados
- Botones en el header
- Iconos opcionales
- Callbacks personalizados

### ✅ Responsive
- Adaptación automática a móvil/desktop
- Layouts diferentes según tamaño de pantalla

## 🔧 Configuración Avanzada

### Personalizar Colores

```dart
// En utils/colors.dart puedes modificar los colores por defecto
class DataTableColors {
  static const Color primary = Color(0xFF417afe);
  static const Color white = Color(0XFFFFFFFF);
  // ... más colores
}
```

### Personalizar Espaciado

```dart
// Usa DataTableSpacing para espaciado consistente
DataTableSpacing.h20  // Espacio vertical de 20
DataTableSpacing.w4   // Espacio horizontal de 4
```

### Usar DataTable3 Directamente

Si solo necesitas el widget base sin paginación:

```dart
DataTable3(
  columns: [
    DataColumn(label: Text('Columna 1')),
    DataColumn(label: Text('Columna 2')),
  ],
  rows: [
    DataRow2(
      cells: [
        DataCell(Text('Dato 1')),
        DataCell(Text('Dato 2')),
      ],
    ),
  ],
)
```

## 📝 Modelo de Datos

### SortColumn

```dart
SortColumn({
  required String label,           // Etiqueta de la columna
  required String field,           // Campo identificador
  bool numeric = false,            // Si es numérica
  Comparable Function(dynamic)? getValue, // Función para obtener valor
})
```

### CustomTableButton

```dart
CustomTableButton({
  required String text,            // Texto del botón
  Icon? icon,                      // Icono opcional
  required VoidCallback onPressed, // Callback
})
```

## 🎯 Ejemplo Completo

```dart
class UserListPage extends StatelessWidget {
  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return CustomPaginatedTable<User>(
      title: 'Lista de Usuarios',
      header: Container(
        padding: EdgeInsets.all(16),
        child: Text('Información de Usuarios'),
      ),
      data: users,
      columns: [
        SortColumn(
          label: 'Nombre',
          field: 'name',
          getValue: (user) => user.name,
        ),
        SortColumn(
          label: 'Email',
          field: 'email',
          getValue: (user) => user.email,
        ),
        SortColumn(
          label: 'Edad',
          field: 'age',
          numeric: true,
          getValue: (user) => user.age,
        ),
      ],
      getCells: (user) => [
        DataCell(Text(user.name)),
        DataCell(Text(user.email)),
        DataCell(Text(user.age.toString())),
      ],
      filterFunction: (user, query) {
        final lowerQuery = query.toLowerCase();
        return user.name.toLowerCase().contains(lowerQuery) ||
               user.email.toLowerCase().contains(lowerQuery);
      },
      actionMenuBuilder: (context, user) => [
        PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Editar'),
            dense: true,
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Eliminar', style: TextStyle(color: Colors.red)),
            dense: true,
          ),
        ),
      ],
      onActionSelected: (action, user) {
        switch (action) {
          case 'edit':
            // Editar usuario
            break;
          case 'delete':
            // Eliminar usuario
            break;
        }
      },
      onRowTap: (user) {
        // Navegar a detalle
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => UserDetailPage(user: user),
        ));
      },
      tableButtons: [
        CustomTableButton(
          text: 'Agregar Usuario',
          icon: Icon(Icons.add),
          onPressed: () {
            // Agregar nuevo usuario
          },
        ),
        CustomTableButton(
          text: 'Exportar',
          icon: Icon(Icons.download),
          onPressed: () {
            // Exportar datos
          },
        ),
      ],
    );
  }
}
```

## 🔄 Migración desde el Proyecto Original

Si estás migrando desde el proyecto original:

1. **Reemplaza imports:**
   ```dart
   // Antes
   import 'package:evochurch/src/widgets/paginateDataTable/paginated_data_table.dart';
   
   // Después
   import 'package:tu_proyecto/components/datatable/datatable_component.dart';
   ```

2. **Reemplaza referencias:**
   - `EvoBox` → `DataTableSpacing`
   - `EvoColor` → `DataTableColors`
   - `Responsive` → `Responsive` (mismo nombre)

3. **El resto del código debería funcionar igual**

## 📦 Dependencias Externas

Este componente requiere:
- `flutter_bloc` - Para gestión de estado
- `flutter_hooks` - Para hooks de React-style

No requiere dependencias adicionales del proyecto original.

## 🐛 Solución de Problemas

### Error: "DataTableBloc not found"
Asegúrate de que `flutter_bloc` esté en tus dependencias.

### Error: "useState not found"
Asegúrate de que `flutter_hooks` esté en tus dependencias.

### Los colores no se ven bien
Puedes personalizar los colores en `utils/colors.dart` o usar el tema de Flutter.

## 📄 Licencia

Este componente es parte del proyecto EvoChurch y puede ser usado libremente.

## 🤝 Contribuciones

Para mejoras o correcciones, por favor crea un issue o pull request.

