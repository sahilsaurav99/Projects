import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { PermissionsGuard } from '../auth/guards/permissions.guard';
import { RequirePermissions } from '../auth/decorators/permissions.decorator';
import { ResourcesService } from './resources.service';
import { CreateResourceDto } from './dto/create-resource.dto';
import { ListResourcesQueryDto } from './dto/list-resources.query';
import { UpdateResourceDto } from './dto/update-resource.dto';

/**
 * ResourcesController
 *
 * Permission keys mirror the course-modules / courses modules:
 *   resources.read   | resources.create | resources.update
 *   resources.delete | resources.restore
 */
@ApiTags('Resources')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller({ path: 'resources', version: '1' })
export class ResourcesController {
  constructor(private readonly resources: ResourcesService) {}

  @Get()
  @RequirePermissions('resources.read')
  @ApiOperation({ summary: 'List resources (paginated, filterable).' })
  @ApiOkResponse({ description: 'Paginated list of resources.' })
  list(@Query() query: ListResourcesQueryDto) {
    return this.resources.findAll(query);
  }

  @Get(':id')
  @RequirePermissions('resources.read')
  @ApiOperation({ summary: 'Get a single resource by id.' })
  findOne(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.resources.findOne(id);
  }

  @Post()
  @RequirePermissions('resources.create')
  @ApiOperation({ summary: 'Create a new resource.' })
  create(@Body() dto: CreateResourceDto) {
    return this.resources.create(dto);
  }

  @Patch(':id')
  @RequirePermissions('resources.update')
  @ApiOperation({ summary: 'Update a resource (partial).' })
  update(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateResourceDto,
  ) {
    return this.resources.update(id, dto);
  }

  @Delete(':id')
  @RequirePermissions('resources.delete')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Soft-delete a resource (sets deletedAt).' })
  remove(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.resources.remove(id);
  }

  @Post(':id/restore')
  @RequirePermissions('resources.restore')
  @ApiOperation({ summary: 'Restore a previously soft-deleted resource.' })
  restore(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.resources.restore(id);
  }
}
