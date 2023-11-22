import { NextFunction, Request, Response } from 'express';
import mongoose from 'mongoose';
import Articulo from '../models/Articulo';
import {mongoosePagination, PaginationOptions } from 'mongoose-paginate-ts';

const createArticulo = (req: Request, res: Response, next: NextFunction) => {
    const { name, description } = req.body;

    const articulo = new Articulo({
        _id: new mongoose.Types.ObjectId(),
        name,
        description
        
    });

    return articulo
        .save()
        .then((articulo) => res.status(201).json(articulo ))
        .catch((error) => res.status(500).json({ error }));
};

const readArticulo= (req: Request, res: Response, next: NextFunction) => {
    const articuloId = req.params.articuloId;

    return Articulo.findById(articuloId)
        .then((articulo) => (articulo ? res.status(200).json( articulo ) : res.status(404).json({ message: 'not found' })))
        .catch((error) => res.status(500).json({ error }));
};

const readAll = (req: Request, res: Response, next: NextFunction) => {
    const page = req.query.page ? parseInt(req.query.page as string, 10) : 1; 
    const options: PaginationOptions = {
        page,
        limit: 3
    };
    return Articulo.paginate(options)
        .then((result) => res.status(200).json(result))
        .catch((error) => res.status(500).json({ error }));
};

const updateArticulo = (req: Request, res: Response, next: NextFunction) => {
    const articuloId = req.params.articuloId;

    return Articulo.findById(articuloId)
        .then((articulo) => {
            if (articulo) {
                articulo.set(req.body);

                return articulo
                    .save()
                    .then((articulo) => res.status(201).json({ articulo }))
                    .catch((error) => res.status(500).json({ error }));
            } else {
                return res.status(404).json({ message: 'not found' });
            }
        })
        .catch((error) => res.status(500).json({ error }));
};

const deleteArticulo = (req: Request, res: Response, next: NextFunction) => {
    const articuloId = req.params.articuloId;

    return Articulo.findByIdAndDelete(articuloId)
        .then((articulo) => (articulo ? res.status(201).json({ articulo, message: 'Deleted' }) : res.status(404).json({ message: 'not found' })))
        .catch((error) => res.status(500).json({ error }));
};

export default { createArticulo, readArticulo, readAll, updateArticulo, deleteArticulo };
