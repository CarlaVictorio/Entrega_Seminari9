import mongoose, { Document, Schema } from 'mongoose';
import {mongoosePagination, Pagination} from 'mongoose-paginate-ts';

export interface IArticulo {
    name: string;
    description: string;
    
}

export interface IArticuloModel extends IArticulo, Document {}

const ArticuloSchema: Schema = new Schema(
    {
        name: { type: String, required: true },
        description: { type: String, required: true }
    },
    {
        versionKey: false
    }
);

ArticuloSchema.plugin(mongoosePagination);
export default mongoose.model<IArticuloModel, Pagination<IArticuloModel>>('Articulo', ArticuloSchema);
