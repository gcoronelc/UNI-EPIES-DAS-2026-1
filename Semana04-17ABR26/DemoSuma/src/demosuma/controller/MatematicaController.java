package demosuma.controller;

import demosuma.service.MatematicaService;

public class MatematicaController {

    private MatematicaService service;

    public MatematicaController() {
        service = new MatematicaService();
    }

    public int sumar(int n1, int n2) {
        return service.sumar(n1, n2);
    }

}
