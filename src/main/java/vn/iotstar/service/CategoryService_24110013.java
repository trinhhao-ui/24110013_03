package vn.iotstar.service;

import vn.iotstar.dao.CategoryDao_24110013;
import vn.iotstar.dao.ICategoryDao_24110013;
import vn.iotstar.entity.Category_24110013;
import java.util.List;

public class CategoryService_24110013 implements ICategoryService_24110013 {
    private ICategoryDao_24110013 categoryDao = new CategoryDao_24110013();

    @Override
    public void insert(Category_24110013 category) {
        categoryDao.insert(category);
    }

    @Override
    public void update(Category_24110013 category) {
        categoryDao.update(category);
    }

    @Override
    public void delete(int categoryId) {
        categoryDao.delete(categoryId);
    }

    @Override
    public Category_24110013 findById(int categoryId) {
        return categoryDao.findById(categoryId);
    }

    @Override
    public List<Category_24110013> findAll() {
        return categoryDao.findAll();
    }

    @Override
    public long countVideosByCategoryId(int categoryId) {
        return categoryDao.countVideosByCategoryId(categoryId);
    }
}
