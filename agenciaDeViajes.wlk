class Pack {
    const diasDeDuracion
    const precioBase
    const beneficiosEspeciales = [ ]
    const coordinador
    method agregarBeneficio(unBeneficio) {
        beneficiosEspeciales.add(unBeneficio)
    }
    method valorFinal() {
        return precioBase + beneficiosEspeciales.sum({b=>b.costo()})
    }
    method esPremium()
    method diasDeDuracion() {
        return diasDeDuracion
    }
    method cantidadBeneficiosVigentes() {
      return beneficiosEspeciales.count({b=>b.estaVigente()})
    }
}
class PackNacional inherits Pack {
    const provinciaDestino
    const actividadesIncluidas = [ ] // nombre en formato texto
    method agregarActividad(unaActividad) {
        actividadesIncluidas.add(unaActividad)
    }
    override method esPremium() {
        return self.diasDeDuracion() > 10 && self.coordinador().estaCalificado()
    }
    method coordinador() {
      return coordinador
    }
    method cantidadDeActividadesDisponibles() {
        return actividadesIncluidas.size()
    }
}
class PackInternacional inherits Pack {
    const paisDestino
    var escalas = 0 
    var lugarDeInteres = true
    method agregarUnaEscala() {
        escalas += 1
    }
    override method valorFinal() {
        return super() * 1.20 
    }
    method esLugarDeInteres() {
        return lugarDeInteres
    }
    method noEsLugarDeInteres() {
        lugarDeInteres = !lugarDeInteres
    }
    override method esPremium() {
        return self.esLugarDeInteres() == true && self.diasDeDuracion() > 20 && escalas == 0
    }
}
class PackProvincial inherits PackNacional {
    var cantidadDeCiudadesVisitadas = 0
    method agregarUnaCiudad(unaCiudad) {
      cantidadDeCiudadesVisitadas += 1
    }
    override method esPremium() {
        return self.cantidadDeActividadesDisponibles() >= 4 && cantidadDeCiudadesVisitadas > 5 && self.cantidadBeneficiosVigentes() >= 3
    }
}
class BeneficioEspecial {
    const tipo
    const costo
    var estaVigente = true
    method costo() {
        return costo
    }  
    method estaVigente() {
        return estaVigente
    }
    method modificarVigencia() {
       estaVigente = !estaVigente
    }
}
class Coordinador {
    var viajesRealizados = 0 
    var estaMotivado = true
    var aniosExperiencia = 0 
    var rol
    const rolesDisponibles = [guia, asistente, acompaniante]
    method estaMotivado() {
        return estaMotivado
    }
    method cambiarMotivacion() {
        estaMotivado = not estaMotivado
    }
    method agregarAniosExperiencia() {
        aniosExperiencia += 1
    }
    method aniosExperiencia() {
        return aniosExperiencia
    }
    method agregarUnViajeRealizado() {
      viajesRealizados += 1
    }
    method cambiarRol(nuevoRol) {
        if (!rolesDisponibles.contains(nuevoRol)) {
            self.error("el rol indicado no es válido")
        } else {
            rol = nuevoRol
        }
    }
    method estaCalificado() {
        return viajesRealizados > 20 && rol.cumpleCondicion(self)
    }
}
object guia {
    method cumpleCondicion(unCoordinador) {
        return unCoordinador.estaMotivado()
    }
}
object asistente {
    method cumpleCondicion(unCoordinador) {
        return unCoordinador.aniosExperiencia() >= 3
    }
}
object acompaniante {
    method cumpleCondicion(unCoordinador) { 
        return true
     }
}