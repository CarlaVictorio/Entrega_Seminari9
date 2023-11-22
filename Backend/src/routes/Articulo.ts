import express from 'express';
import controller from '../controllers/Articulo';
import { Schemas, ValidateSchema } from '../middleware/ValidateSchema';

const router = express.Router();

router.post('/createarticulo', ValidateSchema(Schemas.articulo.create), controller.createArticulo);
router.get('/readarticulo/:articuloId', controller.readArticulo);
router.get('/readall', controller.readAll);
router.put('/updatearticulo/:articuloId', ValidateSchema(Schemas.articulo.update), controller.updateArticulo);
router.delete('/deletearticulo/:articuloId', controller.deleteArticulo);

export = router;
