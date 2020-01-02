using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using TableStorageDemo.Models;
using TableStorageDemo.Repositories;

namespace TableStorageDemo.Controllers
{
    public class TodoController : Controller
    {
        public IConfiguration Configuration { get; }

        public TodoController(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IActionResult Index()
        {
            var repository = new TodoRepository(Configuration);
            var entities = repository.All();

            var models = entities.Select(x => new TodoModel
            {
                Id = x.RowKey,
                Group = x.PartitionKey,
                Content = x.Content,
                DueDate = x.DueDate,
                Completed = x.Completed,
                Timestamp = x.Timestamp,
                CompletedDate = x.CompletedDate
            });

            return View(models);
        }

        public ActionResult Create()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Create(TodoModel model)
        {
            var repository = new TodoRepository(Configuration);
            repository.CreateOrUpdate(new TodoRepository.TodoEntity {
                PartitionKey = model.Group,
                RowKey = Guid.NewGuid().ToString(),
                Content = model.Content,
                DueDate = model.DueDate

            });
            

            return RedirectToAction("Index");
        }

        
        public ActionResult ConfirmEdit(string rowKey, string partitionKey)
        {
            var repository = new TodoRepository(Configuration);
            var x = repository.Get(partitionKey, rowKey);

            return View("Edit", new TodoModel
            {
                Id = x.RowKey,
                Group = x.PartitionKey,
                Content = x.Content,
                DueDate = x.DueDate,
                Completed = x.Completed,
                Timestamp = x.Timestamp
            });
        }

        [HttpPost]
        public ActionResult Edit(TodoModel model)
        {
            var repository = new TodoRepository(Configuration);
            var item = repository.Get(model.Group, model.Id);
            if (model.Completed)
                item.CompletedDate = DateTime.Now;

            item.Completed = model.Completed;
            item.Content = model.Content;
            item.DueDate = model.DueDate;

            repository.CreateOrUpdate(item);

            return RedirectToAction("Index");
        }

        public ActionResult Details(string rowKey, string partitionKey)
        {
            var repository = new TodoRepository(Configuration);
            var x = repository.Get(partitionKey, rowKey);

            return View(new TodoModel
            {
                Id = x.RowKey,
                Group = x.PartitionKey,
                Content = x.Content,
                DueDate = x.DueDate,
                Completed = x.Completed,
                Timestamp = x.Timestamp
            });
        }


        public ActionResult ConfirmDelete(string rowKey, string partitionKey)
        {
            var repository = new TodoRepository(Configuration);
            var x = repository.Get(partitionKey, rowKey);

            return View("Delete", new TodoModel
            {
                Id = x.RowKey,
                Group = x.PartitionKey,
                Content = x.Content,
                DueDate = x.DueDate,
                Completed = x.Completed,
                Timestamp = x.Timestamp
            });
        }

        [HttpPost]
        public ActionResult Delete(string id, string group)
        {
            var repository = new TodoRepository(Configuration);
            var item = repository.Get(group, id);
            repository.Delete(item);

            return RedirectToAction("Index");
        }
    }
}