import wollok.game.*
import naves.*
import lasers.*
import flotaInvader.*

// Instancio un objeto para la musica de fondo
const sonidoMusica = new Sound(file = "aroundTheWorld.mp3")


object inicio {

	var property image = "spaceInvaders.png"

	method iniciar() {
		game.addVisualIn(self, game.at(0, 0)) // Muestra la imagen en la posicion 0,0
		game.schedule(500, { pantallaInicial.iniciar()})
	}

}

object pantallaInicial {

	var property image = "spaceInvaders.png"

	method iniciar() {
		game.addVisualIn(self, game.at(0, 0)) // Muestra la imagen en la posicion 0,0
		sonidoMusica.play() // Inicia la musica de fondo
		configurar.musicaOnOff() // Pausa la musica apretando la "M"
		game.schedule(5000, { image = "instrucciones.png" // Cambia la imagen y pasa al nivel cuando se aprieta enter
			configurar.enterParaJugar()
		})
	}

	method finalizar() {
		game.clear() // Remuevo todos los visual
		self.siguiente().iniciar()
	}

	method siguiente() = nivel1

}

class Nivel {

	method iniciar() {
		game.addVisualIn(self, game.at(0, 0)) // Muestra la imagen en la posicion 0,0
		game.schedule(1000, { game.clear()
			self.iniciarNivel()
		})
	}

	method iniciarNivel() {
		game.addVisual(nave) // Muestro el objeto en pantalla
		nave.irAPosicionInicial() // centro
		configurar.teclas()
		configurar.musicaOnOff()
		configurar.configurarColisiones()
	}

method finalizarNivel() {
		game.schedule(100, { game.clear() })
		game.clear() // Remuevo todos los visual
		game.schedule(500, { self.siguiente().iniciar()})
	}
	method siguiente()

	method image()

}

object nivel1 inherits Nivel {

	override method iniciarNivel() {
		super()
		flotaInvader.crearInvaders(1, 0, game.center().y(), 18)
		flotaInvader.moverInvaders(1000, self)
		flotaInvader.dispararLasersInvaders(3000, self)
		nave.crearVidas()
		nave.mostrarVidas()
	}

	override method siguiente() = nivel2

	override method image() = "nivel1.png"

}

object nivel2 inherits Nivel {

	override method iniciarNivel() {
		super()
		flotaInvader.crearInvaders(4, 6, 1, 18)
		flotaInvader.moverInvaders(1000, self)
		flotaInvader.dispararLasersInvaders(2000, self)
		flotaInvader.iniciarPoderes(4000)
		nave.mostrarVidas()
	}

	override method siguiente() = nivel3

	override method image() = "nivel2.png"

}

object nivel3 inherits Nivel {

	override method iniciarNivel() {
		super()
		flotaInvader.crearInvaders(6, 4, 0, 18)
		flotaInvader.moverInvaders(1000, self)
		flotaInvader.dispararLasersInvaders(1000, self)
		flotaInvader.iniciarPoderes(4000)
		nave.mostrarVidas()
	}

	override method siguiente() = fin

	override method image() = "nivel3.png"

}

object fin {

	var property image // / Cambia segun gane o pierda
	const sonidoPerder = new Sound(file = "sonidoGameOver.wav")
	const sonidoGanar = new Sound(file = "sonidoGanaste.wav")

	method iniciar() { // Ganar
		image = "ganaste.png"
		sonidoGanar.play()
		self.final()
	}

	method perder() {
		image = "gameOver.png"
	    sonidoPerder.play()
		self.final()
	}

	method final() {
		game.clear()
		game.addVisualIn(self, game.at(0, 0))
		configurar.enterParaFin() // Al presionar enterfinaliza
		sonidoMusica.stop()
	}

}

object configurar {

	method teclas() {
		keyboard.left().onPressDo({ nave.moverseIzquierda()})
		keyboard.right().onPressDo({ nave.moverseDerecha()})
		keyboard.space().onPressDo({ nave.disparar()})
	}

	method enterParaJugar() {
		keyboard.enter().onPressDo({ pantallaInicial.finalizar()})
	}

	method enterParaFin() {
		keyboard.enter().onPressDo({ game.stop()})
	}

	method musicaOnOff() {
		keyboard.m().onPressDo({ if (sonidoMusica.paused()) {
				sonidoMusica.resume()
			} else {
				sonidoMusica.pause()
			}
		})
	}

	method configurarColisiones() {
		game.whenCollideDo(nave, { invader => nave.chocarCon(invader)})
	}

}