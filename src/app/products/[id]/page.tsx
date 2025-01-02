import {Product} from '../page'

export default async function ProductById() {
    const res = await fetch('https://fakestoreapi.com/products/1', { cache: 'no-store' });
    const product:Product = await res.json();
    return (<>
    <div>
        <p>productDetail[id]</p>
        <p>{product.title}</p>
        <p>{product.category}</p>
        <p>{product.price}</p>
        <p>{product.image}</p>
        {/* <img src={product.image} alt={product.title} width={200} /> */}
        <p>{product.description}</p>
        <p>{product.rating.rate}</p>
        <p>{product.rating.count}</p>        
    </div>

    </>)
}