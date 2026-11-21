import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart' as auth_state;

import '../../../properties/presentation/bloc/property_bloc.dart';
import '../../../properties/presentation/bloc/property_event.dart';
import '../../../properties/presentation/bloc/property_state.dart';
import '../../../properties/presentation/widgets/property_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(
            create: (context) => getIt<PropertyBloc>()..add(LoadProperties())),
      ],
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView();

  @override
  Widget build(BuildContext context) {
    final authRepo = getIt<AuthRepository>();
    final isOwner = authRepo.currentRole == 'propietario';

    return BlocListener<AuthBloc, auth_state.AuthState>(
      listener: (context, state) {
        if (state is auth_state.AuthInitial) {
          context.go('/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('RentaFácil'),
          actions: [
            IconButton(
              icon: const Icon(Icons.payments_outlined),
              tooltip: 'Historial de Pagos',
              onPressed: () => context.push('/payments'),
            ),
            IconButton(
              icon: const Icon(Icons.build_outlined),
              tooltip: 'Mantenimiento e Incidencias',
              onPressed: () => context.push('/maintenance-list'),
            ),
            IconButton(
              icon: const Icon(Icons.map_outlined),
              tooltip: 'Ver mapa',
              onPressed: () => context.push('/map'),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Cerrar sesión',
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Banner de Rol Profesional (RF2)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: isOwner
                  ? Colors.indigo.shade50
                  : Colors.teal.shade50,
              child: Row(
                children: [
                  Icon(
                    isOwner ? Icons.real_estate_agent : Icons.person_search,
                    color: isOwner ? Colors.indigo : Colors.teal,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isOwner
                          ? 'Panel de Propietario • Gestiona y publica inmuebles'
                          : 'Modo Inquilino • Explora, paga renta y reporta fallas',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: isOwner
                            ? Colors.indigo.shade900
                            : Colors.teal.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  context.read<PropertyBloc>().add(
                        FilterProperties(
                            location:
                                value.trim().isEmpty ? null : value.trim()),
                      );
                },
                decoration: InputDecoration(
                  hintText: 'Buscar por zona, precio o recámaras...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<PropertyBloc, PropertyState>(
                builder: (context, state) {
                  if (state is PropertyLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PropertyError) {
                    return Center(child: Text(state.message));
                  } else if (state is PropertyLoaded) {
                    final properties = state.properties;
                    if (properties.isEmpty) {
                      return const Center(
                          child: Text('No hay propiedades disponibles.'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        return PropertyCard(property: properties[index]);
                      },
                    );
                  }
                  return const Center(
                      child: Text('No hay propiedades disponibles.'));
                },
              ),
            ),
          ],
        ),
        // Botón flotante adaptado al Rol (Propietario publica / Inquilino reporta)
        floatingActionButton: isOwner
            ? FloatingActionButton.extended(
                onPressed: () async {
                  await context.push('/add-property');
                  if (context.mounted) {
                    context.read<PropertyBloc>().add(LoadProperties());
                  }
                },
                icon: const Icon(Icons.add_home),
                label: const Text('Publicar'),
              )
            : FloatingActionButton.extended(
                onPressed: () => context.push('/maintenance-report'),
                icon: const Icon(Icons.report_problem_outlined),
                label: const Text('Reportar Falla'),
              ),
      ),
    );
  }
}