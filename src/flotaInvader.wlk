import wollok.game.*
import naves.*

object flotaInvader {

	const property invaders = []

	method agregarInvader(invader) {
		invaders.add(invader)
	}

	method quitarInvader(invader) {
		invaders.remove(invader)
	}

	method posicionYMasBaja() = invaders.map({ invader => invader.position().y() }).min()

	method filaMasBaja() = invaders.filter({ invader => invader.position().y() == self.posicionYMasBaja() })

	method crearInvaders(cantidad, separacion, xPrimerInvader, y) {
		// Daleks. Los mas malos arriba de todo
		(cantidad - 1).times({ i => self.agregarInvader(new Dalek(position = game.at(xPrimerInvader + (i - 1) * separacion + (separacion / 2), y)))})
		// Los del medio.
		cantidad.times({ i => self.agregarInvader(new Bicho2(position = game.at(xPrimerInvader + (i - 1) * separacion, y - 1)))})
		// Bicho1. Los mas buenitos abajo de todo.
		(cantidad - 1).times({ i => self.agregarInvader(new Bicho1(position = game.at(xPrimerInvader + (i - 1) * separacion + (separacion / 2), y - 2)))})
		self.invaders().forEach({ invader => game.addVisual(invader)})
	}

	method moverInvaders(tiempo, nivel) {
		game.onTick(tiempo, "mover invaders", { self.invaders().forEach({ invader => invader.position(invader.position().right(1))})
			game.schedule(tiempo / 2, { self.invaders().forEach({ invader => invader.position(invader.position().left(1))})})
		})
		game.onTick(tiempo * 4, "Bajar invaders", { self.invaders().forEach({ invader => invader.position(invader.position().down(1))}) // Bajan de posicion
			if (invaders.any({ invader => not invader.estaDentroDeLaPantalla() })) { 
				self.ganoLaInvasion(nivel) // Si al bajar quedo fuera de la pantalla pierde una vida y empieza de nuevo
			}
		})
	}

	// Dispara si hay invaders, el jugador gana si no
	method dispararLasersInvaders(tiempo, nivel) {
		game.onTick(tiempo, "Disparar invaders", { if (not self.invaders().isEmpty()) {
				self.filaMasBaja().anyOne().disparar() // Disparan unicamente los invaders que estan abajo de todo
			} else {
				nivel.finalizarNivel() // Si gana pasa al siguiente nivel
			}
		})
	}

	// Si un invader pasa, resta una vida y empieza de nuevo 
	method ganoLaInvasion(nivel) {
		nave.destruirse()
		invaders.forEach({ invader => invaders.remove(invader)})
		game.clear() // Remuevo todos los visual
		game.schedule(3000, { nivel.iniciar()}) // Faltaria poner alguna presentacion del nivel
	}

method iniciarPoderes(tiempo) {
		game.onTick(tiempo, "Berretines", { 
			if (not self.invaders().isEmpty()) {
			self.filaMasBaja().anyOne().iniciarPoder()
		}
		})
		
	}
	}
	

